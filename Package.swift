// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "PipeModel",
	defaultLocalization: "en",
	platforms: [.macOS(.v10_15), .iOS(.v15)],
	products: [
		.library(
			name: "PipeModel",
			targets: ["PipeModel", "PipeModelObjC"]
		),
	],
	dependencies: [
		// .package(url: /* package url */, from: "1.0.0"),
	],
	targets: [
		.target(
			name: "PipeModelObjC",
			dependencies: [],
			resources: [
				.process("Resources")
			],
			publicHeadersPath: "Headers",
			cSettings: [
				.headerSearchPath("Communicator"),
				.headerSearchPath("Error")
			]
		),
		.target(
			name: "PipeModel",
			dependencies: [
				.target(name: "PipeModelObjC")
			]
		),
		.testTarget(
			name: "PipeModelTests",
			dependencies: [
				.target(name: "PipeModel")
			]
		),
	]
)
