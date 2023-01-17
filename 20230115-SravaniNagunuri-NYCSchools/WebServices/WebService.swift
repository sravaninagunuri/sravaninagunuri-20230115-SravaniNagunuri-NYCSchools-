//
//  WebService.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import Foundation

/// custom protocol for URL session for dependancy injecton
protocol NYCSessionProtocol {
    
    /// data task which will perform network operation
    /// - Returns: NYCURLSessionDataTask
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NYCURLSessionDataTask
    
}

/// Custom protocol for Data task
protocol NYCURLSessionDataTask {
    func resume()
}

/// extenind URL session to confirm NYCSessionProtocol
extension URLSession: NYCSessionProtocol {
    /// Data task which handles
    /// - Parameters:
    ///   - request: URLRequest
    ///   - completionHandler: completionHandler with data , url response and error all are optional
    /// - Returns: NYCURLSessionDataTask
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NYCURLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask as NYCURLSessionDataTask
    }
}

/// Extenind URLSessionDataTask to confirm NYCURLSessionDataTask
extension URLSessionDataTask: NYCURLSessionDataTask {}

class WebService {
    
    let urlSession: NYCSessionProtocol
    let internetReachability: Reachability?
    /// singleton instance for network operations
    public static var instance = WebService(urlSession: URLSession.shared,
                                                reachability: Reachability())

    init(urlSession: NYCSessionProtocol = URLSession.shared, reachability: Reachability? = Reachability()) {
        self.urlSession = urlSession
        self.internetReachability = reachability
        setUpInternetConnectionReachablility()
    }
    
    /// Reachablity start
    func setUpInternetConnectionReachablility() {
        try? internetReachability?.startNotifier()
    }
    
    // check internet availablity
    func internetAvailable() -> Bool {
        var isInternetAvailable = true
        if let connection = internetReachability?.connection {
            isInternetAvailable = getInternetAvailability(connection: connection)
        }
        return isInternetAvailable
    }
    
    /// Get Internet availablity
    /// - Parameter connection: Reachablity connection
    /// - Returns: Boolean
    func getInternetAvailability(connection: Reachability.Connection) -> Bool {
        var isInternetAvailable = true
        switch connection {
        case .cellular, .wifi:
            isInternetAvailable = true
        case .none:
            isInternetAvailable = false
        }
        return isInternetAvailable
    }

    /// Fetch the response data from service with given url and expected decoded data  in required model format.
    func fetchData<T: Decodable>(url: URL, completion: @escaping (T?, Error?) -> ()) {
        
        if !internetAvailable() {
            completion(nil, NYCError.noInternetConnection)
            return
        }
        
        let urlRequest = URLRequest(url: url)
            
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            
           // Error handling
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, error)
                return
            }
                        
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(json, nil)
            } catch(let error) {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
