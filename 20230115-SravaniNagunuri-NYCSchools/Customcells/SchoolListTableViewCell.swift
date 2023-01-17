//
//  SchoolListTableViewCell.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import Foundation
import UIKit

protocol SchoolDetailsDelegate: AnyObject {
    func handleUrl(scheme: ShareScheema, url: String?)
}

class SchoolListTableViewCell: UITableViewCell {
    
    //MARK: - private outlets
    @IBOutlet private weak var schoolNameLbl: UILabel!
    @IBOutlet private weak var schoolCityLbl: UILabel!
    @IBOutlet private weak var detailedView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Initialization code
        detailedView.cardView(radius: 7.0)
    }
    
    func configureSchoolData(school: School?) {
        guard let selectedSchool = school else { return }
        DispatchQueue.main.async {
            self.schoolNameLbl?.text = selectedSchool.schoolName
            self.schoolCityLbl?.text = selectedSchool.city
        }
    }
}
