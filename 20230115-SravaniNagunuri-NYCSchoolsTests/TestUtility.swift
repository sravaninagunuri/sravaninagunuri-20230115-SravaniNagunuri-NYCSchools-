//
//  TestUtility.swift
//  20230115-SravaniNagunuri-NYCSchoolsTests
//
//  Created by Sravani Nagunuri (contractor) on 1/16/23.
//

import XCTest
@testable import _0230115_SravaniNagunuri_NYCSchools

class TestUtility: XCTestCase {

    class func successHttpURLResponse(request: URLRequest) -> URLResponse? {
        if  let url = request.url ?? URL(string: "https://www.google.com") {
            return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        }
        return nil
    }
    
    class func wrongHttpURLResponse(request: URLRequest, statusCode:Int) -> URLResponse?{
        if  let url = request.url ?? URL(string: "https://www.google.com") {
            return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: nil)
        }
        return nil
    }
    
    class func getSchoolModel(dbn: String) -> School? {
        let json =
        ["dbn":dbn,"school_name":"Orchard Collegiate Academy (Henry Street School)","boro":"M","overview_paragraph":"Founded by the Asia Society, our school helps students acquire the knowledge and skills needed to prepare for college and/or careers while in pursuit of knowledge of the histories, economies, and languages of world regions. Teachers and other adults who make up the learning community forge supportive relationships with students and parents while providing challenging and engaging learning experiences. Our school partners with various community, arts, and business organizations to help students achieve success. Our theme of international studies extends beyond the classroom, where students participate in ongoing Â‘Advisory Day OutÂ’ excursions where the multiculturalism of NYC becomes the classroom.","academicopportunities1":"Global/International Studies in core subjects; Literacy block schedule; Personalized instruction in small classes","academicopportunities2":"Student Advisories; International travel opportunities","academicopportunities3":"After-school program focused on youth leadership","academicopportunities4":"Electives courses including Journalism, Technology, and Wellness","academicopportunities5":"Plan to offer AP Biology in September 2016","ell_programs":"English as a New Language","language_classes":"Spanish","advancedplacement_courses":"AP US History","neighborhood":"Lower East Side","shared_space":"Yes","building_code":"M056","location":"220 Henry Street, Manhattan NY 10002 (40.713362, -73.986051)","phone_number":"212-406-9411","fax_number":"212-406-9417","school_email":"mdoyle9@schools.nyc.gov","website":"http://schools.nyc.gov/SchoolPortals/01/M292/default.htm","subway":"B, D to Grand St ; F to East Broadway ; J, M, Z to Delancey St-Essex St","bus":"B39, M14A, M14D, M15, M15-SBS, M21, M22, M9, X14, X37, X38","grades2018":"9-12","finalgrades":"9-12","total_students":"185","start_time":"8:20pm","end_time":"3:55pm","addtl_info1":"Community School","extracurricular_activities":"Student Government/Leadership; Cooking; Boxing; Concert Band; Social Support Club; Storytellers; Social Emotional Learning Groups; Young WomenÂ’s Club, Art and Anime Club. OCA houses a school-based mental health clinic, run by the Henry Street Settlement. Students and families are seen for individual and family therapy","psal_sports_boys":"Basketball","school_sports":"Boxing, Soccer, Wrestling","graduation_rate":"0.638999999","attendance_rate":"0.769999981","pct_stu_enough_variety":"0.699999988","college_career_rate":"0.261999995","pct_stu_safe":"0.730000019","school_accessibility_description":"1","offer_rate1":"Â—5% of offers went to this group","program1":"Orchard Collegiate Academy","code1":"M46X","interest1":"Humanities & Interdisciplinary","method1":"Limited Unscreened","seats9ge1":"68","grade9gefilledflag1":"N","grade9geapplicants1":"112","seats9swd1":"13","grade9swdfilledflag1":"N","grade9swdapplicants1":"30","seats101":"No","admissionspriority11":"Priority to continuing 8th graders","admissionspriority21":"Then to Manhattan students or residents who attend an information session","admissionspriority31":"Then to New York City residents who attend an information session","admissionspriority41":"Then to Manhattan students or residents","admissionspriority51":"Then to New York City residents","grade9geapplicantsperseat1":"2","grade9swdapplicantsperseat1":"2","primary_address_line_1":"220 Henry Street","city":"Manhattan","zip":"10002","state_code":"NY","latitude":"40.71336","longitude":"-73.9861","community_board":"3","council_district":"1","census_tract":"201","bin":"1003223","bbl":"1002690041","nta":"Lower East Side                                                            ","borough":"MANHATTAN"]
        let decoder = JSONDecoder()
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let school = try? decoder.decode(School.self, from: data) {
            return school
        }
        return nil
    }

}

class MyNYCSessionSuccessProtocol: NYCSessionProtocol {
    var resourceName: String
    init(name: String) {
        self.resourceName = name
    }
    
    static var task = MyNYCURLSessionDataTask()
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NYCURLSessionDataTask {
        
        if let path = Bundle(for: WebServicesTest.self).path(forResource: resourceName, ofType: "json") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            completionHandler(data, TestUtility.successHttpURLResponse(request: request), nil)
        }
       return MyNYCSessionSuccessProtocol.task
    }
}

class MyNYCSessionFailureProtocol: NYCSessionProtocol {
    static var task = MyNYCURLSessionDataTask()
    var error: Error?
    var statusCode:Int = 0
    init(status: Int, error: Error? = nil) {
        self.statusCode = status
        self.error = error
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NYCURLSessionDataTask {
        completionHandler(nil, TestUtility.wrongHttpURLResponse(request: request, statusCode: statusCode), error)
       return MyNYCSessionFailureProtocol.task
    }

}

class MyNYCURLSessionDataTask: NYCURLSessionDataTask {
    var isResumeInvoked = false
    func resume() {
        isResumeInvoked = true
    }
}
