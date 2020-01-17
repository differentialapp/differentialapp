//
//  FactorSelectorViewController.swift
//  diagSwiftRealm
//
//  Created by Brian Clow on 1/16/20.
//  Copyright © 2020 Brian Clow. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class FactorSelectorViewController: UIViewController {
    
    let realm = try! Realm()
    var queryResult: Results<Factor>?
    var selectedDiagnosis = "Diagnosis"
    var selectedFactor: Factor?
    
    @IBOutlet weak var diagnosisLabelAtTop: UILabel!
    @IBOutlet weak var factorTableView: UITableView!
    
    override func viewDidLoad() {
        factorTableView.delegate = self
        factorTableView.dataSource = self
        queryResult = realm.objects(Factor.self).filter("diagnosis contains '\(selectedDiagnosis)'").sorted(byKeyPath: "posLR", ascending: false)
        diagnosisLabelAtTop.text = selectedDiagnosis
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SecondViewController
        vc.selectedFactor = selectedFactor
    }
    
}

extension FactorSelectorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryResult!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = factorTableView.dequeueReusableCell(withIdentifier: "FactorCell") as! FactorCell
        let factor = queryResult![indexPath.row]
        cell.setFactor(factor: factor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFactor = queryResult![indexPath.row]
        performSegue(withIdentifier: "dismissFactorModal", sender: self)
    }


}
