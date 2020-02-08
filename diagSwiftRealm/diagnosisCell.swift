//
//  diagnosisCell.swift
//  diagSwiftRealm
//
//

import UIKit

class diagnosisCell: UITableViewCell {
    
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var checkedImage: UIImageView!
    
    func setDiagnosis(diagnosis: String) {
        diagnosisLabel.text = diagnosis
    }
    
    func checked() {
        checkedImage.image = UIImage.checkmark
    }
    
    func unchecked() {
        checkedImage.image = nil
    }

}
