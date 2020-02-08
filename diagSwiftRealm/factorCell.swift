//
//  factorCell.swift
//  diagSwiftRealm
//
//

import UIKit

class FactorCell: UITableViewCell {
    
    @IBOutlet weak var factorLabel: UILabel!
    @IBOutlet weak var posLRLabel: UILabel!
    @IBOutlet weak var negLRLabel: UILabel!
    
    func setFactor(factor: Factor, switchBool: Bool) {
        factorLabel.text = factor.name
        posLRLabel.text = "Positive LR: " + String(factor.posLR)
        negLRLabel.text = "Negative LR: " + String(factor.negLR)
        
        if switchBool {
            posLRLabel.textColor = .gray
            negLRLabel.textColor = .white
        } else {
            posLRLabel.textColor = .white
            negLRLabel.textColor = .gray
        }
    }
}
