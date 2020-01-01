// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name:"DevBoard",
    products:[
        .library(name:"DevBoard", targets:["DevBoard"])
    ],
    targets:[
        .target(name:"DevBoard", dependencies:[])
    ]
)

