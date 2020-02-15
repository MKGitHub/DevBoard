//
//  DevBoard 1.1.0
//
//  Copyright © 2019-2020 Mohsan Khan. All rights reserved.
//


import Foundation
import Combine


/**
    The type that is encoded and sent to the server.
*/
struct DevBoardParameter:Codable
{
    var key:String
    var value:String
    var color:String
    var actions:[Int]
}


@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
final class DevBoard
{
    // MARK: Private/Public Properties

    private(set) var ppAutoUpdatePublisher = PassthroughSubject<DevBoard, Never>()

    // MARK: Private Properties

    private let mJSONEncoder = JSONEncoder()

    private var mIgnoreAllOperations = false
    private var mHost:String!
    private var mParameters = [String:DevBoardParameter]()

    private var mDataTaskPublisherCancellable:AnyCancellable?
    private var mAutoUpdateTimerCancellable:AnyCancellable?
    private var mDispatchQueue = DispatchQueue(label:"DevBoard DispatchQueue",
                                               qos:.background,
                                               attributes:[.concurrent],
                                               autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency.inherit,
                                               target:nil)


    // MARK: - Life Cycle


    /**
        - Parameters:
            - host: Host server URL e.g. http://localhost:8888. Also add a "localhost" key to your `NSAppTransportSecurity` key in your Info.plist.
            - autoUpdateTimeInterval: 0 = no auto update, else in seconds to automatically send an update. This requires that you subscribe to this instance of `DevBoard`.
            - ignoreAllOperations: Set this for debug / release mode of your app. Debug=allow, Release=ignore.
    */
    init(host:String, autoUpdateTimeInterval:Int, ignoreAllOperations:Bool)
    {
        if ignoreAllOperations
        {
            mIgnoreAllOperations = ignoreAllOperations
            return
        }

        mHost = host

        // setup encoder
        //mJSONEncoder.outputFormatting = .prettyPrinted
        mJSONEncoder.dataEncodingStrategy = .base64
        mJSONEncoder.keyEncodingStrategy = .useDefaultKeys

        if (autoUpdateTimeInterval >= 1) {
            setupAutoUpdateWithTimeInterval(autoUpdateTimeInterval)
        }
    }


    deinit
    {
        mDataTaskPublisherCancellable?.cancel()
        mAutoUpdateTimerCancellable?.cancel()
    }


    /**
        Thread safe.

        - Parameters:
            - index: At which index the key/value should be positioned i.e. sort order.
            - key: Name/label to display.
            - value: The value.
            - color: Any color that is supported by HTML/CSS, also HEX values are supported. E.g. "red" or "#ff0000". Default to standard color.
            - actions: 1 = Blink animation, else leave empty for default text display. Default to no action.
    */
    func setParameter(atIndex index:UInt, key:String, value:String, color:String="", actions:[Int]=[])
    {
        if mIgnoreAllOperations
        {
            return
        }

        let parameter = DevBoardParameter(key:key, value:value, color:color, actions:actions)
        let indexString = String(index)

        mDispatchQueue.async(flags:.barrier)
        {
            self.mParameters[indexString] = parameter
        }
    }


    /**
        - Sends the parameters to the server.
        - You will not get any status back.
        - This is pretty much a try-retry + fire-and-forget call.
        - Thread safe.
    */
    func sendUpdate()
    {
        if mIgnoreAllOperations
        {
            return
        }

        // return to app immediately
        DispatchQueue.global().async
        {
            [weak self] in
            guard let self = self else { Swift.print("[📺 DevBoard] Failed to send update, `self` does not exist!"); return }
            self.sendUpdateToServer()
        }
    }


    // MARK: - Private


    private func setupAutoUpdateWithTimeInterval(_ timeInterval:Int)
    {
        if mIgnoreAllOperations
        {
            return
        }

        mAutoUpdateTimerCancellable = Timer.publish(every:TimeInterval(timeInterval), on:.main, in:.default)
        .autoconnect()
        .sink
        {
            [weak self] receivedTimeStamp in
            guard let self = self else { Swift.print("[📺 DevBoard] Failed to send auto update, `self` does not exist!"); return }
            //Swift.print("Timer.publish:", receivedTimeStamp)
            self.ppAutoUpdatePublisher.send(self)

            self.sendUpdate()
        }
    }


    private func sendUpdateToServer()
    {
        if mIgnoreAllOperations
        {
            return
        }
        
        // encode parameters to data
        guard
            let jsonData = try? mJSONEncoder.encode(self),
            let jsonString = String(data:jsonData, encoding:.utf8),
            let escapedString = jsonString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
            else
        {
            Swift.print("[📺 DevBoard] Failed to encode into JSON format!")
            return
        }

        let url = mHost + "/DevBoardReceiver.php?devBoard=" + escapedString

        // send to the server receiver page
        mDataTaskPublisherCancellable = URLSession.shared.dataTaskPublisher(for:URL(string:url)!)
            .retry(3)
            .receive(on:DispatchQueue.global(qos:.background))
            .sink(receiveCompletion:
            {
                (completion) in
                //print("completion:", completion)
            },
            receiveValue:
            {
                (output) in
                //print("output:", output)
            })
    }
}


// MARK: - Codable


/**
    Add `Codable` support.
*/
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
extension DevBoard:Codable
{
    // MARK: - Private Enum

    private enum CodingKeys:String, CodingKey
    {
        case mParameters = "parameters"
    }


    // MARK: - Life Cycle


    func encode(to encoder:Encoder) throws
    {
        var container = encoder.container(keyedBy:CodingKeys.self)

        mDispatchQueue.sync(flags:.barrier)
        {
            guard ((try? container.encode(self.mParameters, forKey:.mParameters)) != nil) else
            {
                Swift.print("[📺 DevBoard] Encoder failed!")
                return
            }
        }
    }
}


// MARK: - Publisher


/**
    Make it a publisher.
*/
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
extension DevBoard:Publisher
{
    // MARK: - Type Alias

    typealias Output = DevBoard
    typealias Failure = Never


    // MARK: - Life Cycle


    func receive<S>(subscriber:S) where S:Subscriber,
        DevBoard.Output == S.Input,
        DevBoard.Failure == S.Failure
    {
        ppAutoUpdatePublisher.subscribe(subscriber)
    }
}

