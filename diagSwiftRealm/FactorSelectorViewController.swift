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
    
    var realm: Realm?
    var queryResult: Results<Factor>?
    var selectedDiagnosis = "Diagnosis"
    var selectedFactor: Factor?
    var negLRBool = false
    var factorNumber: Int = 1
    
    @IBOutlet weak var diagnosisLabelAtTop: UILabel!
    @IBOutlet weak var factorTableView: UITableView!
    
    override func viewDidLoad() {
        factorTableView.delegate = self
        factorTableView.dataSource = self

        diagnosisLabelAtTop.text = selectedDiagnosis
        
        let config = Realm.Configuration(
            fileURL: Bundle.main.url(forResource: "dataSet", withExtension: "realm"),
            readOnly: true)

        realm = try! Realm(configuration: config)
        
        queryResult = realm?.objects(Factor.self).filter("diagnosis contains '\(selectedDiagnosis)'").sorted(byKeyPath: "posLR", ascending: false)
    }
    
    
    @IBAction func negLRSwitch(_ sender: UISwitch) {
        
        // CHANGES COLOR OF LIKELIHOOD RATIOS BASED ON WHICH IS SELECTED, GRAYS OUT UNSELECTED
        
        if sender.isOn {
            negLRBool = true
            factorTableView.reloadData()
        } else {
            negLRBool = false
            factorTableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // PASSES SELECTION BACK TO ROCKET OBJECT
        
        let vc = segue.destination as! SecondViewController
        if factorNumber == 1 {
            vc.rocket1?.factor = selectedFactor
            vc.rocket1?.negLRBoolean = negLRBool
            vc.rocket1?.factorSelected = true
        } else {
            vc.rocket2?.factor = selectedFactor
            vc.rocket2?.negLRBoolean = negLRBool
            vc.rocket2?.factorSelected = true
        }
    }
    
}

extension FactorSelectorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryResult!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = factorTableView.dequeueReusableCell(withIdentifier: "FactorCell") as! FactorCell
        let factor = queryResult![indexPath.row]
        cell.setFactor(factor: factor, switchBool: negLRBool)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFactor = queryResult![indexPath.row]
        performSegue(withIdentifier: "dismissFactorModal", sender: self)
    }

}
