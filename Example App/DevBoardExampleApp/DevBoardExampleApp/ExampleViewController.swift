//
//  Copyright © 2019-2020 Mohsan Khan. All rights reserved.
//

import UIKit
import Combine


private enum Parameter:UInt
{
    case appStartDateTime
    case appLastHeartbeat
    case viewController
    case viewControllerExtraSubscriber
    case lastButtonTapped
    case animated

    var index:UInt { return self.rawValue }
}


final class ExampleViewController:UIViewController
{
    // MARK: Private Properties

    private var devBoard:DevBoard!
    private var devBoardSubscriber1:AnyCancellable!
    private var devBoardSubscriber2:AnyCancellable!


    // MARK: - Life Cycle


    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupDevBoard()
    }


    deinit
    {
        devBoardSubscriber1.cancel()
        devBoardSubscriber2.cancel()
    }


    // MARK: - IBActions


    @IBAction func didTapButton1(_ button:UIButton)
    {
        print("didTapButton1")
        devBoard.setParameter(atIndex:Parameter.lastButtonTapped.index, key:"Last Button Tapped",
                              value:button.currentTitle!, color:"#55FF55", actions:[2])
        devBoard.sendUpdate()
    }


    @IBAction func didTapButton2(_ button:UIButton)
    {
        print("didTapButton2")
        devBoard.setParameter(atIndex:Parameter.lastButtonTapped.index, key:"Last Button Tapped",
                              value:button.currentTitle!, color:"#55FF55", actions:[2])
        devBoard.sendUpdate()
    }


    // MARK: - Private


    private func setupDevBoard()
    {
        devBoard = DevBoard(host:"http://localhost:8888", autoUpdateTimeInterval:2, ignoreAllOperations:false)

        devBoard.setParameter(atIndex:Parameter.appStartDateTime.index, key:"App Started",
                              value:Date().description, color:"", actions:[])

        devBoard.setParameter(atIndex:Parameter.animated.index, key:"Animated",
                              value:"🍿", color:"", actions:[1])

        // subscribe to DevBoard auto updates
        devBoardSubscriber1 = devBoard.sink
        {
            devBoard in

            print("devBoardSubscriber1 called")

            // update parameter
            devBoard.setParameter(atIndex:Parameter.appLastHeartbeat.index, key:"Last 💓",
                                  value:Date().description, color:"pink", actions:[])
            devBoard.setParameter(atIndex:Parameter.viewController.index, key:"View Controller",
                                  value:"ExampleViewController", color:"", actions:[])
        }

        // extra example, showing multiple subscribers at work
        devBoardSubscriber2 = devBoard.sink
        {
            devBoard in

            print("devBoardSubscriber2 called")

            let randomRed = Int.random(in:0...9)
            let randomGreen = Int.random(in:0...9)
            let randomBlue = Int.random(in:0...9)
            let randomColor = String(format:"#%d%d%d", randomRed, randomGreen, randomBlue)

            // update parameter
            devBoard.setParameter(atIndex:Parameter.viewControllerExtraSubscriber.index,
                                  key:"View Controller, extra subscriber",
                                  value:randomColor, color:randomColor, actions:[])
        }
    }
}

