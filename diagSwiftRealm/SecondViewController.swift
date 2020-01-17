//
//  SecondViewController.swift
//  diagSwiftRealm
//
//  Created by Brian Clow on 1/15/20.
//  Copyright © 2020 Brian Clow. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    
    
    @IBOutlet weak var shipPic1: UIImageView!
    @IBOutlet weak var arcView: CounterView!
    @IBOutlet weak var topDirectiveLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    
//    var shipPic: UIImageView?
    var preTestProbability: Double = 10.0
    var preTestLabel = UILabel()
    var readyForSelection = false
    var selectedDiagnoses: [String] = []
    var selectedFactor: Factor?
    var launchButton: UIButton?
    var finalShowLabel = UILabel()
    var finalShowBool = false
    
    override func viewDidLoad() {
//        super.viewDidLoad()
//        shipPic = UIImageView()
//        shipPic?.image = UIImage(named: "spaceShip.png")
        view.addSubview(shipPic1)
        shipPic1.center = CGPoint(x: 52.10828290506163, y: 646.0)
        if selectedFactor != nil {
            print(selectedFactor!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !readyForSelection {
            for touch in touches {

                //________________________________
                //Uses Pythagorean Theorem to calculate location on arc
                //
                //________________________________
                //
                // b = sqrt( c2 - a2 )
                //
                // c = radius of arc, defined in arcClass (3 * hvar / 2 - 2.5)
                // a = touch y coordinate (tyvar) - arc center y coordinate (cyvar)
                
                
                let location = touch.location(in: self.view)
                
                var ylocation: CGFloat = 0
                
                let bottomBound = arcView.center.y + arcView.frame.height / 2 //Was 683 before
                let upperBound = arcView.center.y - arcView.frame.height / 2 + shipPic1.frame.height
                
                if location.y < upperBound {
                    ylocation = upperBound
                } else if location.y > bottomBound {
                    ylocation = bottomBound
                } else {
                    ylocation = location.y
                }
                
                let xlocation = moveRocket(yvalue: ylocation)
                
                if shipPic1.frame.contains(location) {
                    shipPic1.center = CGPoint(x: xlocation, y: ylocation)
                    let range = Double(bottomBound - upperBound)
                    preTestProbability = (range - (Double(ylocation) - Double(upperBound))) / (range / 100)
                    
                    //preTestLabel?.font =
                    let labelText = "Pre-test Probability: \n" + String(format:"%.1f", preTestProbability) + "%"
                    preTestLabel.text = labelText
                    preTestLabel.backgroundColor = UIColor.white
                    preTestLabel.textAlignment = .center
                    preTestLabel.numberOfLines = 2
                    preTestLabel.layer.masksToBounds = true
                    preTestLabel.layer.cornerRadius = 10
                    preTestLabel.sizeToFit()
                    preTestLabel.center = CGPoint(x: xlocation + 60, y: ylocation + 60)
                    view.addSubview(preTestLabel)
                }
            }
        } else {
            for touch in touches {
                let location = touch.location(in: self.view)
                if shipPic1.frame.contains(location) && !finalShowBool {
                    performSegue(withIdentifier: "modalFactorSegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FactorSelectorViewController
        vc.selectedDiagnosis = selectedDiagnoses[0]
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !readyForSelection {
            for touch in touches {
                
                let location = touch.location(in: self.view)
                
                var ylocation: CGFloat = 0
                
                let bottomBound = arcView.center.y + arcView.frame.height / 2 //Was 683 before
                let upperBound = arcView.center.y - arcView.frame.height / 2 + shipPic1.frame.height
                
                if location.y < upperBound {
                    ylocation = upperBound
                } else if location.y > bottomBound {
                    ylocation = bottomBound
                } else {
                    ylocation = location.y
                }
                
                let xlocation = moveRocket(yvalue: ylocation)

                if shipPic1.frame.contains(location) {
                    shipPic1.center = CGPoint(x: xlocation, y: ylocation)
                    preTestLabel.center = CGPoint(x: xlocation + 60, y: ylocation + 60)
                    let range = Double(bottomBound - upperBound)
                    preTestProbability = (range - (Double(ylocation) - Double(upperBound))) / (range / 100)
                    let labelText = "Pre-test Probability: \n" + String(format:"%.1f", preTestProbability) + "%"
                    preTestLabel.text = labelText
                }
                

            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !readyForSelection {
            preTestLabel.removeFromSuperview()
        }
    }
    
    @IBAction func changeToSelectionMode(_ sender: Any) {
        readyForSelection = true
        topDirectiveLabel.text = "Now tap each ship to select a test / exam finding"
        readyButton.removeFromSuperview()
    }
    
    @IBAction func backUpTo2(_ sender: UIStoryboardSegue) {
        launchButton = UIButton()
        launchButton!.setTitle("Launch", for: .normal)
        launchButton!.frame = CGRect(x: 10, y: 100, width: 200, height: 90)
        launchButton!.backgroundColor = UIColor.blue
        launchButton!.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
        launchButton!.addTarget(self, action: #selector(launchRocket), for: .touchUpInside)
        view.addSubview(launchButton!)
        //print(selectedFactor)
    }
    
    func moveRocket(yvalue: CGFloat) -> CGFloat {
        let sxvar = (arcView.center.x - arcView.frame.width / 2)
        let cxvar = sxvar + (3 * arcView.frame.width)
        let hvar = arcView.frame.height
        let tyvar = yvalue
        let cyvar = (1.25 * arcView.frame.height) + (arcView.center.y - arcView.frame.height/2)
        let bvar2 = ( pow(((3 * hvar)/2 - 2.5),2) - pow(cyvar - tyvar, 2) )
        let xlocation = cxvar - bvar2.squareRoot()
        
        return xlocation
    }
    
    @objc func launchRocket() {
        print("LAUNCHING ROCKET")
        
        let preTestOdds = (preTestProbability/100) / (1 - (preTestProbability/100))
        let postTestOdds = preTestOdds * (selectedFactor?.posLR ?? 1.0) //FIX LATER, ERROR EXIT?
        let postTestProbability = (postTestOdds / (1 + postTestOdds))
        
        print("Post Test Probability", postTestProbability)
        
        let bottomBound = arcView.center.y + arcView.frame.height / 2 //Was 683 before
        let upperBound = arcView.center.y - arcView.frame.height / 2 + shipPic1.frame.height
        let range = Double(bottomBound - upperBound)
        let yposition = (range - (postTestProbability * range)) + Double(upperBound)
        let yCG = CGFloat(yposition)
        let xposition = moveRocket(yvalue: yCG)
        let finalPosition = CGPoint(x: xposition, y: yCG)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            self.shipPic1.center = finalPosition
            }, completion: nil)
        
        //shipPic1.center = finalPosition
        launchButton?.removeFromSuperview()
        let notFound = "Not Found"
        
        var stringPosLR = ""
        var stringNegLR = ""
        let percPTProb = postTestProbability * 100
        let stringPercPTProb = String(format: "%.1f", percPTProb)
        
        
        if selectedFactor != nil {
            stringPosLR = String(selectedFactor!.posLR)
            stringNegLR = String(selectedFactor!.negLR)
        } else {
            stringPosLR = notFound
            stringNegLR = notFound
        }
        // Now show labels
        
        finalShowLabel.text =
            """
            Diagnosis: \(selectedFactor?.diagnosis ?? notFound)
            Finding: \(selectedFactor?.name ?? notFound)
            Positive Likelihood Ratio: \(stringPosLR)
            Negative Likelihood Ratio: \(stringNegLR)
            Pre-test Probability: \(preTestProbability)%
            Post-test Probability: \(stringPercPTProb)%
            """
        
        finalShowLabel.backgroundColor = UIColor.white
        finalShowLabel.textAlignment = .center
        finalShowLabel.numberOfLines = 6
        finalShowLabel.layer.masksToBounds = true
        finalShowLabel.layer.cornerRadius = 10
        finalShowLabel.sizeToFit()
        finalShowLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
        view.addSubview(finalShowLabel)
        topDirectiveLabel.text = "All Finished!"
        finalShowBool = true
    }
}

