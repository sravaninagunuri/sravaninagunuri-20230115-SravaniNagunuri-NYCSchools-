//
//  SchoolsListViewController.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import UIKit

class SchoolsListViewController: UIViewController {
    
    //MARK: - constants
    private enum Constants {
        static let erroMessage = NSLocalizedString("No search results found.", comment: "No search results found..")
    }
    
    //MARK: - private outlets
    @IBOutlet private weak var schoolsListTableView: UITableView!
    @IBOutlet private weak var errorMessageLbl: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    //MARK: - variables
    var refreshControl: UIRefreshControl!
    var selectedSchool: School?
    let spinner = UIActivityIndicatorView(style: .large)

    lazy var schoolsListVM = SchoolsListViewModel()
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        /// set searchbar delegate
        searchBar.delegate = self
        spinner.color = .white
        errorMessageLbl?.text = Constants.erroMessage
        errorMessageLbl?.isHidden = true
        addRefreshControl()
        getSchoolsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(self.spinner)
        self.spinner.center = self.view.center
        navigationItem.title = "NYC Schools"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - private methods
    
    /// Add refreshcontrol to tableview
    private func addRefreshControl() {
        refreshControl = UIRefreshControl()
         if let refreshControl = refreshControl {
             refreshControl.tintColor = .systemBackground
             refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:[NSAttributedString.Key.foregroundColor: UIColor.systemBackground])
             refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
             schoolsListTableView.addSubview(refreshControl)
         }
     }
    
    /// show activity indicator on main queue
    private func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.startAnimating()
            self?.errorMessageLbl.isHidden = true
        }
    }
    
    /// hide activity indicator on main queue
    private func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.stopAnimating()
            self?.spinner.hidesWhenStopped = true
            self?.refreshControl?.endRefreshing()
        }
    }
    
    /// refreshing UI when user pulls the screen
    @objc func refresh(_ sender: AnyObject) {
        getSchoolsData()
    }
    
    /// API call to get list of schools from given URL
    func getSchoolsData() {
        
        showActivityIndicator()
        schoolsListVM.fetchSchoolsData { [weak self] error in
            guard let strongSelf = self else {
                return
            }
            defer {
                strongSelf.hideActivityIndicator()
                DispatchQueue.main.async {
                    strongSelf.schoolsListTableView.reloadData()
                }
            }
            if let error = error {
                Utilities.alert(title: "Error", message: error.localizedDescription, contoller: strongSelf)
            }
        }
    }
    
}
//MARK: - tableview datasource
extension SchoolsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        errorMessageLbl.isHidden = (schoolsListVM.filteredSchools?.count != 0)
        schoolsListTableView.isHidden = !(schoolsListVM.filteredSchools?.count != 0)
        return schoolsListVM.filteredSchools?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SchoolListTableViewCell
        if let school = schoolsListVM.filteredSchools?[indexPath.row] {
            cell.configureSchoolData(school: school)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedSchool = schoolsListVM.filteredSchools?[indexPath.row]
        return indexPath
    }
}

//MARK: - tableview delegate
extension SchoolsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailsVC = storyBoard.instantiateViewController(withIdentifier: "SchoolDetailsViewControllerID") as! SchoolDetailViewController
        detailsVC.school = selectedSchool
        self.navigationController?.present(detailsVC, animated: true, completion: nil)
    }
}

//MARK: - searchbar delegate
extension SchoolsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        schoolsListVM.filterSchools(searchText: searchBar.text ?? "")
        schoolsListTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        schoolsListVM.filterSchools(searchText: searchBar.text ?? "")
        schoolsListTableView.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        schoolsListVM.filterSchools(searchText: searchBar.text ?? "")
        schoolsListTableView.reloadData()
    }
}
