//
//  URLsTests.swift
//  20230115-SravaniNagunuri-NYCSchoolsTests
//
//  Created by Sravani Nagunuri (contractor) on 1/16/23.
//

import XCTest
@testable import _0230115_SravaniNagunuri_NYCSchools

class URLsTests: XCTestCase {

    func testURLs() throws {
        XCTAssertEqual(URLs.rootURLstring, "https://data.cityofnewyork.us")
        XCTAssertEqual(URLs.schoolDirectoryURL.path, "/resource/s3k6-pzi2.json")
        XCTAssertEqual(URLs.getResultURL(dbn: "02M260").path, "/resource/f9bf-2cp4.json")
    }

}
