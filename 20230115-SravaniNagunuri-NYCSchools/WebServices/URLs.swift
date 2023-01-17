//
//  URLs.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import Foundation

enum URLs {
    
    static let rootURLstring = "https://data.cityofnewyork.us"
    
    static let baseURL: URL = {
        guard let url = URL(string: rootURLstring) else {
          fatalError("Invalid baseURL")
        }
        return url
    }()
    
    static let schoolDirectoryURL: URL = {
        guard let url = URL(string: "\(rootURLstring)/resource/s3k6-pzi2.json") else {
          fatalError("Invalid url")
        }
        return url
    }()
    
    static func getResultURL(dbn: String?) -> URL {
        
        guard let dbn = dbn, let url = URL(string: "\(rootURLstring)/resource/f9bf-2cp4.json?dbn=\(dbn)") else {
          fatalError("invalid URL")
        }
        return url
    }
}
