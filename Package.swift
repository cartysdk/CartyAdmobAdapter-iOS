
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CartyAdmobAdapter",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CartyAdmobAdapter",
            targets: ["CartyAdmobAdapter"]
        ),
    ],
    dependencies:[
        .package(url: "https://github.com/cartysdk/Carty-swift-package-manager.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "CartyAdmobAdapter",
            path: "CartyAdmobAdapter",
        ),

    ]
)
