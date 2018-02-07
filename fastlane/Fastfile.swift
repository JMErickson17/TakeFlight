// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
    
	func releaseLane() {
	desc("Push a new release build to the App Store")
        incrementVersionNumber()
        incrementBuildNumber()
		buildApp(workspace: "TakeFlight.xcworkspace", scheme: "TakeFlight")
		uploadToAppStore(username: "JMEricksonDev@gmail.com", app: "com.JustinErickson.TakeFlight")
	}
    
    func testLane() {
        desc("Run all tests.")
            runTests()
    }
}
