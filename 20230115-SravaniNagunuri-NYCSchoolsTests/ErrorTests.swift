//
//  ErrorTests.swift
//  20230115-SravaniNagunuri-NYCSchoolsTests
//
//  Created by Sravani Nagunuri (contractor) on 1/16/23.
//

import XCTest
@testable import _0230115_SravaniNagunuri_NYCSchools

class ErrorTests: XCTestCase {

    func testError() throws {
        let error1 = NYCError.internalServerError
        XCTAssertEqual(error1.errorDescription, "Internal server error.")
        let error2 = NYCError.noInternetConnection
        XCTAssertEqual(error2.errorDescription, "Not connected to Internet.")
        let error3 = NYCError.timeout
        XCTAssertEqual(error3.errorDescription, "Request timed out.")
    }

}
