
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
    dependencies: [
        .package(url:"https://github.com/cartysdk/Carty-swift-package-manager", from: "0.6.0"),
        .package(url:"https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "CartyAdmobAdapter",
            path: "CartyAdmobAdapter",
            dependencies: [
                .product(name: "CartySDK", package: "Carty-swift-package-manager")
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
        ),

    ]
)
