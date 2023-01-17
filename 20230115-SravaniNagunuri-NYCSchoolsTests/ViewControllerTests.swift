//
//  ViewControllerTests.swift
//  20230115-SravaniNagunuri-NYCSchoolsTests
//
//  Created by Sravani Nagunuri (contractor) on 1/16/23.
//

import XCTest
@testable import _0230115_SravaniNagunuri_NYCSchools

class ViewControllerTests: XCTestCase {

    var schoolsListVC: SchoolsListViewController?
    var schoolsDetailVC: SchoolDetailViewController?
    
    
    override func setUpWithError() throws {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let schoolsVC = storyBoard.instantiateViewController(withIdentifier: "SchoolsViewControllerID") as? SchoolsListViewController {
            schoolsVC.loadViewIfNeeded()
            schoolsListVC = schoolsVC
        }
    }

    override func tearDownWithError() throws {
        schoolsListVC = nil
        schoolsDetailVC = nil
    }

    func testSchoolControlelr() throws {
        XCTAssertNotNil(schoolsListVC)
        let myurlSession = MyNYCSessionSuccessProtocol(name: "schools")
        let networkManager = WebService(urlSession: myurlSession)
        let listViewModel = SchoolsListViewModel()
        let expectation = XCTestExpectation(description: "wait for url response")
        listViewModel.fetchSchoolsData(networkManager: networkManager) { error in
            expectation.fulfill()
            XCTAssertNotNil(listViewModel.schools)
            XCTAssertNotNil(listViewModel.filteredSchools)
            XCTAssertNotNil(listViewModel.filterSchools(searchText:"A"))
        }
        self.wait(for: [expectation], timeout: 1)

        let expectation2 = XCTestExpectation(description: "load tableview")

        schoolsListVC?.schoolsListVM = listViewModel
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation2.fulfill()
        }
        self.wait(for: [expectation2], timeout: 5)
    }
        
    func testDetailController() throws {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "SchoolDetailsViewControllerID") as? SchoolDetailViewController {
            schoolsDetailVC = controller
            controller.school = TestUtility.getSchoolModel(dbn: "01M292")
            XCTAssertNotNil(schoolsDetailVC?.view)
            schoolsDetailVC?.viewDidLoad()

            let expectation = XCTestExpectation(description: "load view")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                expectation.fulfill()
            }
            self.wait(for: [expectation], timeout: 6)
            schoolsDetailVC?.handleUrl(scheme: .https, url: "www.google.com")
        }
    }
    
    func testUtility() throws {
        if let schoolsListVC = schoolsListVC {
            XCTAssertNoThrow(Utility.open(scheme: .telprompt, urlString: "", contoller: schoolsListVC))
            XCTAssertNoThrow(Utility.open(scheme: .https, urlString: "www.google.com", contoller: schoolsListVC))
        }
    }

}
