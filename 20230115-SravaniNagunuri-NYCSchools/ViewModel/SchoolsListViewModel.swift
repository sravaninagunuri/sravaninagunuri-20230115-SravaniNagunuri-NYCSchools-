//
//  SchoolsListViewModel.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import Foundation


class SchoolsListViewModel: NSObject {
    
    //MARK: - private properties
    var schools: [School]? = [School]()
    var filteredSchools: [School]? = [School]()
    
    //MARK: - methods
    
    /// Fetch schools list from backend api
    /// - Parameters:
    ///   - networkManager: network manager object
    ///   - completionHandler: completion handler to be passed which contain optional error
    func fetchSchoolsData(
        networkManager: WebService = WebService.instance,
        completionHandler: @escaping (Error?) -> Void
    ) {
        networkManager.fetchData(url: URLs.schoolDirectoryURL) { [weak self] (response: [School]?, error) in
            
            self?.schools = response
            self?.filteredSchools = self?.schools?.sorted(by: { school1, school2 in
                var status = false
                if let name1 = school1.schoolName, let name2 = school2.schoolName {
                    status = name1 < name2
                }
                return status
            })
            completionHandler(error)
        }
    }
    
    /// Filter school list with given search text
    /// - Parameter searchText: String
    ///  filter the schools list with given string
    func filterSchools(searchText: String) {
        filteredSchools = searchText.isEmpty ?
        schools :
        schools?.filter { school in
            return school.schoolName?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
}
