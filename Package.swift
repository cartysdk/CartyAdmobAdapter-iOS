
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
        .package(url: "https://github.com/cartysdk/Carty-swift-package-manager.git", from: "0.6.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "CartyAdmobAdapter",
            dependencies:[
                .product(name: "CartySDK", package: "carty-swift-package-manager"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ],
            path: "CartyAdmobAdapter",
            publicHeadersPath:"../CartyAdmobAdapter"
        ),

    ]
)
