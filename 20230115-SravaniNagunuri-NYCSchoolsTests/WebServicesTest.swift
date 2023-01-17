//
//  WebServicesTest.swift
//  20230115-SravaniNagunuri-NYCSchoolsTests
//
//  Created by Sravani Nagunuri (contractor) on 1/16/23.
//

import XCTest
@testable import _0230115_SravaniNagunuri_NYCSchools

class WebServicesTest: XCTestCase {
    
    func testHandleNetworkErrorResponse() throws {
        
        class MyNYCSessionProtocol: NYCSessionProtocol {
            func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NYCURLSessionDataTask {
                return MyNYCURLSessionDataTask()

            }
        }
        class MyNetworkManager: WebService {
            override func internetAvailable() -> Bool {
              return false
            }
        }
        
        struct ModelObject: Decodable {
            let name: String
        }
        
        let myNetworkManager = MyNetworkManager(urlSession: MyNYCSessionProtocol())
        XCTAssertFalse(myNetworkManager.getInternetAvailability(connection: .none))
        let expectation = XCTestExpectation(description: "wait for url response")

        if let url = URL(string: "https://www.google.com") {
            myNetworkManager.fetchData(url: url) { (obj: ModelObject?, error) in
                expectation.fulfill()
                XCTAssertNotNil(error, "error is nil")
            }
        }
        self.wait(for: [expectation], timeout: 1)
    }

    func testNetworkSuccess() throws {

        let expectation = XCTestExpectation(description: "wait for url response")

        let myurlSession = MyNYCSessionSuccessProtocol(name: "details")
        let networkManager = WebService(urlSession: myurlSession)
        
        if let url = URL(string: "https://www.google.com") {
            networkManager.fetchData(url: url) { (obj: [Scores]?, error) in
                XCTAssertNotNil(obj)
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 1)

        XCTAssertTrue(MyNYCSessionSuccessProtocol.task.isResumeInvoked)
    }
    
    func testNetworkFailure1() throws {

        let myurlSession = MyNYCSessionFailureProtocol(status: 400, error: NYCError.internalServerError)
        let network = WebService(urlSession: myurlSession)
        XCTAssertFalse(network.getInternetAvailability(connection: .none))
        let expectation = XCTestExpectation(description: "wait for url response")

        if let url = URL(string: "https://www.google.com") {
           network.fetchData(url: url) { (obj: [School]?, error) in
               XCTAssertNotNil(error)
               expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkFailure2() throws {

        struct User: Decodable {
            var name: String
        }
        
        let myurlSession = MyNYCSessionSuccessProtocol(name: "schools")
        let network = WebService(urlSession: myurlSession)
        XCTAssertFalse(network.getInternetAvailability(connection: .none))
        let expectation = XCTestExpectation(description: "wait for url response")

        if let url = URL(string: "https://www.google.com") {
           network.fetchData(url: url) { (obj: [User]?, error) in
               XCTAssertNotNil(error)
               expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkFailure3() throws {

        struct User: Decodable {
            var name: String
        }
        
        let myurlSession = MyNYCSessionFailureProtocol(status: 400, error: nil)
        let network = WebService(urlSession: myurlSession)
        XCTAssertFalse(network.getInternetAvailability(connection: .none))
        let expectation = XCTestExpectation(description: "wait for url response")

        if let url = URL(string: "https://www.google.com") {
           network.fetchData(url: url) { (obj: [User]?, error) in
               XCTAssertNil(error)
               expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 1)
    }

    func testNetworkFailure4() throws {

        struct User: Decodable {
            var name: String
        }

        let myurlSession = MyNYCSessionFailureProtocol(status: 200, error: nil)
        let network = WebService(urlSession: myurlSession)
        XCTAssertFalse(network.getInternetAvailability(connection: .none))
        let expectation = XCTestExpectation(description: "wait for url response")

        if let url = URL(string: "https://www.google.com") {
           network.fetchData(url: url) { (obj: [User]?, error) in
               XCTAssertNil(error)
               expectation.fulfill()
            }
        }
        self.wait(for: [expectation], timeout: 1)
    }

}
