//
//  Copyright © 2019-2020 Mohsan Khan. All rights reserved.
//

import UIKit
import Combine


final class ExampleViewController:UIViewController
{
    private let devBoard = DevBoard(host:"http://localhost:8888", autoUpdateTimeInterval:2, ignoreAllOperations:true)

    private var devBoardSubscriber1:AnyCancellable!
    private var devBoardSubscriber2:AnyCancellable!


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


    @IBAction func didTapButton1(_ button:UIButton)
    {
        print("didTapButton1")
        devBoard.setParameter(atIndex:2, key:"Last Button Tapped", value:button.currentTitle!, color:"#55FF55", actions:[2])
        devBoard.sendUpdate()
    }


    @IBAction func didTapButton2(_ button:UIButton)
    {
        print("didTapButton2")
        devBoard.setParameter(atIndex:2, key:"Last Button Tapped", value:button.currentTitle!, color:"#55FF55", actions:[2])
        devBoard.sendUpdate()
    }


    private func setupDevBoard()
    {
        devBoard.setParameter(atIndex:4, key:"Animated", value:"🍿", color:"", actions:[1])

        // subscribe to DevBoard auto updates
        devBoardSubscriber1 = devBoard.sink
        {
            devBoard in

            print("devBoardSubscriber1 called")

            // update parameter
            devBoard.setParameter(atIndex:0, key:"View Controller", value:"ExampleViewController", color:"", actions:[])
            devBoard.setParameter(atIndex:1, key:"Date/Time", value:Date().description, color:"cyan", actions:[])
        }

        // extra example of multiple subscribers allowed and work as expected
        devBoardSubscriber2 = devBoard.sink
        {
            devBoard in

            print("devBoardSubscriber2 called")

            let randomRed = Int.random(in:0...9)
            let randomGreen = Int.random(in:0...9)
            let randomBlue = Int.random(in:0...9)
            let randomColor = String(format:"#%d%d%d", randomRed, randomGreen, randomBlue)

            // update parameter
            devBoard.setParameter(atIndex:3, key:"View Controller, extra subscriber", value:randomColor, color:randomColor, actions:[])
        }
    }
}

