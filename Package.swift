// swift-tools-version:4.2

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

