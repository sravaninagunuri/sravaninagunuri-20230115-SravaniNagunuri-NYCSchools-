//
//  Utility.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import UIKit

class Utility {
    /// Utility function to show alert
    /// - Parameters:
    ///   - title: String alert title
    ///   - message: String alert message
    ///   - contoller: UIViewController on which alert should be displayed
    static func alert(
        title: String,
        message: String,
        contoller: UIViewController
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            contoller.present(alert, animated: true, completion: nil)
        }
    }

    /// Handling of open URLs  outside of application and errors while opening urls
    /// - Parameters:
    ///   - scheme: String scheme
    ///   - urlString: String url to be opened
    ///   - contoller: UIViewController on which alert should be displayed incase of error
    static func open(
        scheme: ShareScheema,
        urlString: String?,
        contoller: UIViewController
    ) {
        
        var errorMessage = ""
        
        switch scheme {
        case .telprompt:
            errorMessage = "Unable to make call from Simulator"
        case .https:
            errorMessage = "Unable to open webpage"
        case .mailto:
            errorMessage = "Unable to open mailbox"
        }
        
        guard let urlString = urlString,
              let url = URL(string: "\(scheme)://\(urlString)"),
              UIApplication.shared.canOpenURL(url) else {
                  Utilities.alert(
                    title: "Warning!",
                    message: errorMessage,
                    contoller: contoller
                  )
                  return
              }
        UIApplication.shared.open(url)
    }
}


///Utility Enum to use scheema
///telprompt - used to make calls
///https - appends as prefix to webstire string to open page in web browser
///mailto - used to send mails
///
enum ShareScheema {
    case telprompt
    case https
    case mailto
}

class Utilities {
    /// Utility function to show alert
    /// - Parameters:
    ///   - title: String alert title
    ///   - message: String alert message
    ///   - contoller: UIViewController on which alert should be displayed
    ///
    static func alert(
        title: String,
        message: String,
        contoller: UIViewController
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        DispatchQueue.main.async {
            contoller.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Handling of open URLs  outside of application and errors while opening urls
    /// - Parameters:
    ///   - scheme: String scheme
    ///   - urlString: String url to be opened
    ///   - contoller: UIViewController on which alert should be displayed incase of error
    static func open(
        scheme: ShareScheema,
        urlString: String?,
        contoller: UIViewController
    ) {
        
        var errorMessage = ""
        
        switch scheme {
        case .telprompt:
            errorMessage = "Unable to make call from Simulator"
        case .https:
            errorMessage = "Unable to open webpage"
        case .mailto:
            errorMessage = "Unable to open mailbox"
        }
        
        guard let urlString = urlString,
              let url = URL(string: "\(scheme)://\(urlString)"),
              UIApplication.shared.canOpenURL(url) else {
                  Utilities.alert(
                    title: "Warning!",
                    message: errorMessage,
                    contoller: contoller
                  )
                  return
              }
        UIApplication.shared.open(url)
    }
}
