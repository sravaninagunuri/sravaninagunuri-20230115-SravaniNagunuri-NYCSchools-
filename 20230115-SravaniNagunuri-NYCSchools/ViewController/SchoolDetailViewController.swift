//
//  SchoolDetailViewController.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import Foundation
import UIKit
import MapKit

class SchoolDetailViewController: UIViewController {
    
    //MARK: - private outlets
    
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var mathLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var writingLabel: UILabel!
    
    
    @IBOutlet weak var SchoolAddress: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    
    @IBOutlet weak var emailImage: UIButton!
    @IBOutlet weak var websiteImage: UIButton!
    @IBOutlet weak var phoneImage: UIButton!
    @IBOutlet weak var mapImage: UIButton!
    
    
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var satDetailView: UIView!
    @IBOutlet weak var ContactInfoView: UIView!
    @IBOutlet weak var studentInfoView: UIView!
    
    @IBOutlet weak var sports: UILabel!
    @IBOutlet weak var interests: UILabel!
    @IBOutlet weak var totalStudents: UILabel!
    
    weak var delegate: SchoolDetailsDelegate?
    
    var score: Scores?
    var school: School?
    
    lazy var detailViewModel = SchoolDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        fetchScores()
    }
    
    /// It will fetch scores from view model and display them in tableview.
    private func fetchScores() {
        
        if let school = school {
            detailViewModel.getDetails(school: school) { [weak self] (response: [Scores]?, error) in
                
                if response == nil {
                    
                    DispatchQueue.main.async {
                        let alert =  UIAlertController(title: "Alert", message: "This school dont have information", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self?.present(alert, animated: true, completion: nil)
                        
                        self?.ContactInfoView.isHidden = true
                        self?.satDetailView.isHidden = true
                        self?.studentInfoView.isHidden = true
                        self?.schoolName.isHidden = true
                        self?.shareBtn.isHidden = true
                    }
                    return
                }
                if let score = response?.first(where: { $0.dbn == self?.school?.dbn }) {
                    self?.score = score
                }
                DispatchQueue.main.async {
                    self?.ContactInfoView.isHidden = false
                    self?.ContactInfoView.isHidden = false
                    self?.satDetailView.isHidden = false
                    self?.studentInfoView.isHidden = false
                    self?.schoolName.isHidden = false
                    self?.shareBtn.isHidden = false
                    self?.updateUI()
                }
            }
        }
    }
    
    /// Updating UI with selected school information
    func updateUI() {
        /// school name and school information
        self.schoolName?.text = school?.schoolName
        
        /// SAT score details for selected school
        self.mathLabel?.text = score?.math
        self.readingLabel?.text = score?.reading
        self.writingLabel?.text = score?.writing
        
        /// School Contact Information like Address, email,phone number, website
        self.SchoolAddress?.text = school?.location
        self.email?.text = school?.email
        self.phoneNumber?.text = school?.phone
        self.websiteLbl?.text = school?.website
        
        self.sports?.text = school?.sports
        self.interests?.text = school?.interest
        self.totalStudents?.text = school?.totalStudents
        
        delegate = self
    }
}

// MARK: - SchoolDetailsDelegate
extension SchoolDetailViewController: SchoolDetailsDelegate {
  
    func handleUrl(scheme: ShareScheema, url: String?) {
        Utility.open(scheme: scheme, urlString: url, contoller: self)
    }
}

// MARK: - Button Actions
extension SchoolDetailViewController {
    
    @IBAction func navigateToEmail() {
        delegate?.handleUrl(
            scheme: .mailto,
            url: "mailto:\(self.school?.email ?? "")"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        )
    }
    
    @IBAction func navigateToWebsite() {
        delegate?.handleUrl(scheme: .https, url: self.school?.website)
    }
    
    @IBAction private func callPhone() {
        delegate?.handleUrl(scheme: .telprompt, url: self.school?.phone)
    }
    
    @IBAction private func navigateToMaps() {
        if let lattitude = school?.latitude, let longtitude = school?.longitude {
            let address = "maps.google.com/maps?ll=\(lattitude),\(longtitude)"
            delegate?.handleUrl(scheme: .https, url: address)
        }
    }
    
    @IBAction private func shareDetailsBtnTapped () {
        let activityVC = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}

