//
//  ViewController.swift
//  diagSwiftRealm
//
//  Created by Brian Clow on 1/11/20.
//  Copyright © 2020 Brian Clow. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var queryResult: Results<Factor>?
    var searchController: UISearchController!
    var uniqueDiagnoses: [String] = []
    var queriedDiagnoses: [String] = []
    var selectedDiagnoses: [String] = []
    
    var realm: Realm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tableView.delegate = self
        tableView.dataSource = self
        doneButton.isUserInteractionEnabled = false
        
        
        
    }

    func setup() {
        view.backgroundColor = .white
        
        
        //Set up Model / Realm Database
        //------------------------------
        let config = Realm.Configuration(
        // Get the URL to the bundled file
        fileURL: Bundle.main.url(forResource: "dataSet", withExtension: "realm"),
        // Open the file in read-only mode as application bundles are not writeable
        readOnly: true)
        // Open the Realm with the configuration
        realm = try! Realm(configuration: config)

        queryResult = realm?.objects(Factor.self).sorted(byKeyPath: "diagnosis", ascending: true)
        for each in queryResult! {
            if !uniqueDiagnoses.contains(each.diagnosis!) {
                uniqueDiagnoses.append(each.diagnosis!)
            }
        }
        queriedDiagnoses = uniqueDiagnoses
        
        //Configure Search
        searchBar.delegate = self
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
    }
    
    // HANDLE SEARCH QUERIES
    // -----------------------------------------------------------
    
    func filterDiagsFromSearch(searchTerm: String) {
        if searchTerm.count > 0 {
            queryResult = realm?.objects(Factor.self).filter("diagnosis contains '\(searchTerm)'")
            createDiagList()
        }
    }
    
    
    @IBAction func resetDiagnoses(_ sender: Any) {
        //CLEAR SELECTION, RESET DATABASE QUERY TO ALL
        resetDiagnoses2()
    }
    
    func resetDiagnoses2() {
        queriedDiagnoses = uniqueDiagnoses
        selectedDiagnoses = []
        tableView.reloadData()
        searchBar.text = ""
    }
    
    func createDiagList() {
        queriedDiagnoses = selectedDiagnoses
        for each in queryResult! {
            if !selectedDiagnoses.contains(each.diagnosis!) {
                if !queriedDiagnoses.contains(each.diagnosis!) {
                    queriedDiagnoses.append(each.diagnosis!)
                }
            }
            
        }
        tableView.reloadData()
    }
    
    // -----------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SecondViewController
        vc.selectedDiagnoses = selectedDiagnoses
    }
    
}

// DELEGATES FOR SEARCH / SEARCH BAR
// -----------------------------------------------------------

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
        if let searchText = searchBar.text {
            filterDiagsFromSearch(searchTerm: searchText)
        }
        tableView.reloadData()
    }
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterDiagsFromSearch(searchTerm: searchText)
        }
    }
}

// DELEGATES FOR TABLE
// -----------------------------------------------------------

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // LIMITS CHOICES TO 2, ONLY ADDS IF UNIQUE, OTHERWISE SENDS ALERT
        
        if selectedDiagnoses.count < 2 {
            if !selectedDiagnoses.contains(queriedDiagnoses[indexPath.row]) {
                selectedDiagnoses.append(queriedDiagnoses[indexPath.row])
                doneButton.isUserInteractionEnabled = true
                doneButton.setTitle("Done", for: .normal)
                doneButton.backgroundColor = UIColor.systemIndigo
            }
        } else {
            let alertController = UIAlertController(title: "Limit reached", message: "Only 2 diagnoses at a time", preferredStyle: .alert)
            searchController.isActive = false
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        createDiagList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queriedDiagnoses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // WHEN CELL SELECTED, CREATES CHECKMARK OBJECT AND MOVES IT TO THE TOP OF ROWS
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "Cell") as! diagnosisCell)
        let diag = queriedDiagnoses[indexPath.row]
        cell.setDiagnosis(diagnosis: diag)
        if indexPath.row < selectedDiagnoses.count {
            cell.checked()
        } else {
            cell.unchecked()
        }
        return cell
    }
}
