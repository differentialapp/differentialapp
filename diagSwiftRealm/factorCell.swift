//
//  factorCell.swift
//  diagSwiftRealm
//
//  Created by Brian Clow on 1/16/20.
//  Copyright © 2020 Brian Clow. All rights reserved.
//

import UIKit

class FactorCell: UITableViewCell {
    
    @IBOutlet weak var factorLabel: UILabel!
    @IBOutlet weak var posLRLabel: UILabel!
    @IBOutlet weak var negLRLabel: UILabel!
    
    func setFactor(factor: Factor) {
        factorLabel.text = factor.name
        posLRLabel.text = "Positive LR: " + String(factor.posLR)
        negLRLabel.text = "Negative LR: " + String(factor.negLR)
    }
}
