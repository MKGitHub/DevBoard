[![MadeInSweden](https://img.shields.io/badge/Made_In-Stockholm_Sweden-blue.svg)](https://en.wikipedia.org/wiki/Stockholm)
[![Status](https://img.shields.io/badge/Status-Active_and_in_development-blue.svg)](https://github.com/MKGitHub/DevBoard)

[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](https://github.com/MKGitHub/DevBoard)
[![Carthage](https://img.shields.io/badge/Carthage-1.0.0-blue.svg)](https://github.com/MKGitHub/DevBoard)
[![SPM](https://img.shields.io/badge/SPM-1.0.0-blue.svg)](https://github.com/MKGitHub/DevBoard)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-🤬-blue.svg)](https://github.com/MKGitHub/DevBoard)

[![Languages](https://img.shields.io/badge/Languages-Swift_PHP_HTML_JS_CSS-blue.svg)](https://github.com/MKGitHub/DevBoard)
[![Swift](https://img.shields.io/badge/Swift_Version-5.1.x-blue.svg)](https://github.com/MKGitHub/DevBoard)


🌟 Give this repo a star and help its development grow! 🌟


DevBoard
------
The console is great for logging and keeping track of whats going on in your app, whether you do logging in Xcode in the Terminal.app or the Console.app. But all that logging is sometimes and often just too much 🤯🤦‍♂️, and you easily loose important information.

Here comes DevBoard to the rescue!

With DevBoard you can keep track of exactly what you want and see exactly only that! BOOM! Elevator pitch nailed it!


![View](https://github.com/MKGitHub/DevBoard/blob/master/Images/view.jpg)


How It Works
------
###### Short Story
* You run the built-in macOS PHP server.
* You send parameters from your app to a page on the server, which then saves those parameters to a JSON file.
* That JSON file with those parameters are displayed in another web page.

###### Long Story
In the `www` folder double click `Run_DevBoard_Server.command` to run it, this will start the built-in macOS PHP server on `localhost:8888` and use the root directory of the command file.

Then the two web pages in the `www` folder will be opened `DevBoardReceiver.php` and `DevBoardViewer.php`.

The `DevBoardReceiver.php` page will first launch with example parameters, which will be saved to the `DevBoard_Log.json` file.

The `DevBoardViewer.php` page will read the JSON file and display those parameters.

You can now start using DevBoard in your app.

Please see the provided `DevBoardExampleApp` for Swift.

###### Swift Story
```swift
// init
let devBoard = DevBoard(host:"http://localhost:8888", autoUpdateTimeInterval:2)

// set a parameter
devBoard.setParameter(atIndex:0, key:"Button Tapped", value:"Green Button", color:"#00FF00", actions:[])

// manually send update to server
devBoard.sendUpdate()

// At this point… watch your web browser for an update :-)

// if you prefer to use auto updates, subscribe to DevBoard
var devBoardSubscriber = devBoard.sink
{
    devBoard in
    devBoard.setParameter(atIndex:1, key:"Date/Time", value:Date().description, color:"cyan", actions:[])
}

```

###### Setting a Parameter
* Index: At which index the key/value should be positioned i.e. sort order.
* Actions: 1 = Apply blinking animation to key-value.


Requirements
------
* Swift 5.1.x
* Xcode 11.x
* Combine framework


How to Install
------
DevBoard has a plain & simple distibution, simply add the `DevBoard.swift` to your project.

* Git: `git clone https://github.com/MKGitHub/DevBoard.git`.
* Carthage: In your Cartfile add `github "MKGitHub/DevBoard"`.
* Swift Package Manager: Needs swift-tools-version:5.1.


Roadmap
------
* Add more support for theming in the viewer page.
* Add more CSS themes.
* Add support for playing sound actions.
* Figure out more cool actions to implement.
* Add a specific numerical parameter type which can be used to draw diagrams/graphs with historical values.
* Add a specific numerical parameter type which can be used to draw a range as horizontal or cirular progress.
* Add support for sending/displaying images.
* Add support for displaying the navigation stack of an app with screenhots of each view controller (horizontal).
* Add support for displaying the view hierarchy of an app with screenhots (vertical, z-index).


Pull Requests
------
Currently not accepting any random pull requests, please create an issue first where a discussion can take place.


Notes
------
https://github.com/MKGitHub/DevBoard

Copyright 2019 Mohsan Khan

Licensed under the Apache License, Version 2.0

