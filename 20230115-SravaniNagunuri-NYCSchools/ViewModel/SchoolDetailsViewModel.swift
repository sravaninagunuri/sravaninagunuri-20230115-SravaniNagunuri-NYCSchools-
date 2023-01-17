//
//  SchoolDetailsViewModel.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import Foundation

class SchoolDetailsViewModel {
    
    /// Fetch Schools details from backend api
    /// - Parameters:
    ///   - networkManager: network manager instance
    ///   - school: School model object
    ///   - completionHandler: completion handler with optional scores and  optional error
    func getDetails(
        networkManager: WebService = WebService.instance,
        school: School,
        completionHandler: @escaping (([Scores]?, Error?) -> Void)
    ) {
        networkManager.fetchData(url: URLs.getResultURL(dbn: school.dbn)) { (response: [Scores]?, error) in
            
            if (response?.first(where: { $0.dbn == school.dbn })) != nil {
                completionHandler(response, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
