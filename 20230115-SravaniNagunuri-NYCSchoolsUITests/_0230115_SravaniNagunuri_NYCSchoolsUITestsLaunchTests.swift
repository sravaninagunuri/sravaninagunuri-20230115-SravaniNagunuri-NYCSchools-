//
//  _0230115_SravaniNagunuri_NYCSchoolsUITestsLaunchTests.swift
//  20230115-SravaniNagunuri-NYCSchoolsUITests
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import XCTest

class _0230115_SravaniNagunuri_NYCSchoolsUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
