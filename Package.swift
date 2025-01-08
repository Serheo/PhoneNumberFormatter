// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwiftPhoneNumberFormatter",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "PhoneNumberFormatter",
            targets: ["PhoneNumberFormatter"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PhoneNumberFormatter",
            dependencies: [],
            path: "PhoneNumberFormatter/Sources"
        ),
        .testTarget(
            name: "PhoneNumberFormatterTests",
            dependencies: ["PhoneNumberFormatter"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
