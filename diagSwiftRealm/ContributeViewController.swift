//
//  ContributeViewController.swift
//

import UIKit
import MessageUI

class ContributeViewController: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var factorField: UITextField!
    @IBOutlet weak var diagnosisField: UITextField!
    @IBOutlet weak var posLRField: UITextField!
    @IBOutlet weak var negLRField: UITextField!
    @IBOutlet weak var sourceField: UITextView!
    @IBOutlet weak var commentsField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        factorField.delegate = self
        diagnosisField.delegate = self
        posLRField.delegate = self
        negLRField.delegate = self
        sourceField.delegate = self
        commentsField.delegate = self
        scrollView.delegate = self
        scrollView.contentSize.height = 498 
    }
    
    
    
    @IBAction func sendEmailAction(_ sender: Any) {
        if let text = factorField.text, text.isEmpty {
            sendAlert(field: "test")
        } else if let text = diagnosisField.text, text.isEmpty {
            sendAlert(field: "diagnosis")
        } else if let text = posLRField.text, text.isEmpty {
            sendAlert(field: "Positive LR")
        } else if let text = negLRField.text, text.isEmpty {
            sendAlert(field: "Negative LR")
        } else if let text = sourceField.text, text.isEmpty {
            sendAlert(field: "Source")
        } else {
            sendEmail(factor: factorField.text!, diagnosis: diagnosisField.text!, posLR: posLRField.text!, negLR: negLRField.text!, source: sourceField.text, comment: commentsField.text!)
        }
    }
    
    func sendAlert(field: String) {
        let alertController = UIAlertController(title: "Missing field", message: "Please enter a \(field)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func sendEmail(factor: String, diagnosis: String, posLR: String, negLR: String, source: String, comment: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["differentialapp@protonmail.com"])
            mail.setSubject("Application Contribution")
            mail.setMessageBody(
                """
                <h1>Contribution</h1>
                <p>
                Test: \(factor)
                Diagnosis: \(diagnosis)
                Positive LR: \(posLR)
                Negative LR: \(negLR)
                Source: \(source)
                Comment: \(comment)
                </p>
                """, isHTML: true)

            present(mail, animated: true)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Unable to send email", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}


extension ContributeViewController: UITextFieldDelegate, UITextViewDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}


