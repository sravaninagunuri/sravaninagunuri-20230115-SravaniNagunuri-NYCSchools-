//
//  School.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

struct School: Decodable {
    
    var dbn: String?
    var schoolName: String?
    var overviewParagraph: String?
    var latitude: String?
    var longitude: String?
    var totalStudents: String?
    var location: String?
    var phone: String?
    var email: String?
    var website: String?
    var city: String
    var interest: String
    var address: String?
    var zip: String?
    var sports: String?
    
    enum CodingKeys: String, CodingKey {
        case dbn, latitude, longitude, location, website, city
        case schoolName = "school_name"
        case overviewParagraph = "overview_paragraph"
        case totalStudents = "total_students"
        case phone = "phone_number"
        case email = "school_email"
        case interest = "interest1"
        case address = "primary_address_line_1"
        case zip = "zip"
        case sports = "school_sports"
    }
    
}
