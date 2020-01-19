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
    @IBOutlet weak var shipPic2: UIImageView!
    @IBOutlet weak var arcView: CounterView!
    @IBOutlet weak var arcView2: CounterView2!
    @IBOutlet weak var topDirectiveLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    
    var preTestLabel = UILabel()
    var preTestLabel2 = UILabel()
    var readyForSelection = false
    var selectedDiagnoses: [String] = []
    var launchButton = UIButton()
    var finalShowBool = false
    var negLRBoolean = false
    var shipSelected: Int = 1
    var finalShowLabel1 = UILabel()
    var finalShowLabel2 = UILabel()
    var rocket1: Rocket?
    var rocket2: Rocket?
    var finalShowButton1: UIButton?
    var finalShowButton2: UIButton?
    
    override func viewDidLoad() {
        view.addSubview(shipPic1)
        
        shipPic1.center = CGPoint(x: 52.10828290506163, y: 646.0)
        shipPic2.center = CGPoint(x: 255.85491373152524, y: 719.3333282470703)
        
        if  selectedDiagnoses.count == 1 {
            rocket1 = Rocket(diagnosis: selectedDiagnoses[0], imageContainer: shipPic1, arcContainer: arcView, preTestProbability: 10.0)
        } else if selectedDiagnoses.count == 2 {
            view.bringSubviewToFront(arcView2)
            rocket1 = Rocket(diagnosis: selectedDiagnoses[0], imageContainer: shipPic1, arcContainer: arcView, preTestProbability: 10.0)
            rocket2 = Rocket(diagnosis: selectedDiagnoses[1], imageContainer: shipPic2, arcContainer: arcView2, preTestProbability: 10.0)
            rocket2?.arcOpensRight = false
            view.addSubview(shipPic2)
            view.bringSubviewToFront(shipPic2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // HANDLE TOUCH EVENTS
    // HANDLE MOVEMENT WITH DRAGGING
    // -----------------------------------------------------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !readyForSelection {
            for touch in touches {
                let location = touch.location(in: self.view)
                
                if shipPic2.frame.contains(location) {
                    let ylocation = rocket2?.containWithInBounds(yvalue: location.y)
                    
                    //Move Ship
                    //------------------
                    let xlocation = rocket2?.move(yTouchValue: ylocation!)
                    shipPic2.center = CGPoint(x: xlocation!, y: ylocation!)
                    
                    //Calculate PreTest Prob
                    rocket2?.setPreTest(yvalue: ylocation!)
                    
                    //Create label
                    preTestLabel2 = rocket2?.makePreTestLabel() ?? UILabel()
                    preTestLabel2.center = CGPoint(x: xlocation! - 60, y: ylocation! + 60)
                    view.addSubview(preTestLabel2)
                }
                
                if shipPic1.frame.contains(location) {
                    let ylocation = rocket1?.containWithInBounds(yvalue: location.y)
                    //Move Ship
                    //------------------
                    let xlocation = rocket1?.move(yTouchValue: ylocation!)
                    shipPic1.center = CGPoint(x: xlocation!, y: ylocation!)
                    
                    //Calculate PreTest Prob
                    rocket1?.setPreTest(yvalue: ylocation!)
                    
                    //Create label
                    preTestLabel = rocket1?.makePreTestLabel() ?? UILabel()
                    preTestLabel.center = CGPoint(x: xlocation! + 60, y: ylocation! + 60)
                    view.addSubview(preTestLabel)
                }
                
            }
        } else {
            for touch in touches {
                let location = touch.location(in: self.view)
                if shipPic1.frame.contains(location) && !finalShowBool {
                    shipSelected = 1
                    performSegue(withIdentifier: "modalFactorSegue", sender: self)
                }
                if shipPic2.frame.contains(location) && !finalShowBool {
                    shipSelected = 2
                    performSegue(withIdentifier: "modalFactorSegue", sender: self)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !readyForSelection {
            for touch in touches {
                
                let location = touch.location(in: self.view)
                
                if shipPic2.frame.contains(location) {
                    let ylocation = rocket2?.containWithInBounds(yvalue: location.y)
                    
                    //Move Ship
                    //------------------
                    
                    let xlocation = rocket2?.move(yTouchValue: ylocation!)
                    shipPic2.center = CGPoint(x: xlocation!, y: ylocation!)

                    //Calculate PreTest Prob and Update Label
                    rocket2?.setPreTest(yvalue: ylocation!)
                    let labelText = "\(rocket2?.diagnosis ?? "Not found")\nPre-test Probability: \n" + String(format:"%.1f", rocket2!.preTestProbability) + "%"
                    preTestLabel2.text = labelText
                    preTestLabel2.center = CGPoint(x: xlocation! - 60, y: ylocation! + 60)
                }
                
                if shipPic1.frame.contains(location) {
                    
                    let ylocation = rocket1?.containWithInBounds(yvalue: location.y)
                    
                    //Move Ship
                    //------------------
                    
                    let xlocation = rocket1?.move(yTouchValue: ylocation!)
                    shipPic1.center = CGPoint(x: xlocation!, y: ylocation!)
                    
                    //Calculate PreTest Prob
                    rocket1?.setPreTest(yvalue: ylocation!)
                    
                    //Calculate PreTest Prob and Update Label
                    let labelText = "\(rocket1?.diagnosis ?? "Not Found")\nPre-test Probability: \n" + String(format:"%.1f", rocket1!.preTestProbability) + "%"
                    preTestLabel.text = labelText
                    preTestLabel.center = CGPoint(x: xlocation! + 60, y: ylocation! + 60)
                }

            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !readyForSelection {
            preTestLabel.removeFromSuperview()
            preTestLabel2.removeFromSuperview()
        }
    }
    
    // IBACTIONS: Change between different modes
    // -----------------------------------------------------------
    
    @IBAction func changeToSelectionMode(_ sender: Any) {
        readyForSelection = true
        topDirectiveLabel.text = "Now tap each ship to select a test / exam finding"
        readyButton.removeFromSuperview()
    }
    
    @IBAction func backUpTo2(_ sender: UIStoryboardSegue) {
        launchButton.setTitle("Launch!", for: .normal)
        launchButton.frame = CGRect(x: 10, y: 100, width: 200, height: 90)
        launchButton.backgroundColor = UIColor.systemIndigo
        launchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        launchButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
        launchButton.addTarget(self, action: #selector(launchAllRockets), for: .touchUpInside)
        view.addSubview(launchButton)
    }
    
    // SEGUE PREP
    // -----------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FactorSelectorViewController
        if shipSelected == 1 {
            vc.selectedDiagnosis = rocket1!.diagnosis
        } else if shipSelected == 2 {
            vc.selectedDiagnosis = rocket2!.diagnosis
            vc.factorNumber = 2
        }
        
    }
    
    // ROCKET LAUNCH
    // -----------------------------------------------------------
    
    @objc func launchAllRockets() {
        if rocket1?.factorSelected ?? false {
            let finalPosition = rocket1?.launch()
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
                self.shipPic1.center = finalPosition!
                }, completion: nil)
            finalShowLabel1 = (rocket1?.createFinalLabel())!
            finalShowLabel1.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
            finalShowButton1 = createNumberButton(forWhat: "showLabel1")
            view.addSubview(finalShowLabel1)
            view.addSubview(finalShowButton1!)
        }
        if rocket2?.factorSelected ?? false {
            let finalPosition = rocket2?.launch()
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
                self.shipPic2.center = finalPosition!
                }, completion: nil)
            finalShowLabel2 = (rocket2?.createFinalLabel())!
            finalShowLabel2.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
            finalShowButton2 = createNumberButton(forWhat: "showLabel2")
            view.addSubview(finalShowLabel2)
            view.addSubview(finalShowButton2!)
        }
        topDirectiveLabel.text = "All Finished!"
        finalShowBool = true
        view.bringSubviewToFront(finalShowLabel1)
        launchButton.removeFromSuperview()
    }
    
    // CREATE BUTTONS ABOVE FINAL RESULTS LABEL, TO ALLOW VIEWING EACH IN A TAB VIEW TYPE FORMAT
    // -----------------------------------------------------------
    
    func createNumberButton(forWhat: String) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        button.backgroundColor = UIColor.clear
        button.tintColor = .white
        
        if forWhat == "showLabel1" {
            button.setTitle("Show: ", for: .normal)
            button.setImage(UIImage(systemName: "1.circle.fill"), for: .normal)
            button.center = CGPoint(x: UIScreen.main.bounds.width / 4, y: finalShowLabel1.frame.minY - 20)
            //button.imageEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            button.addTarget(self, action: #selector(bringView1ToFront), for: .touchUpInside)
        } else if forWhat == "showLabel2" {
            
            button.setTitle("Show: ", for: .normal)
            button.setImage(UIImage(systemName: "2.circle.fill"), for: .normal)
            button.center = CGPoint(x: 3 * UIScreen.main.bounds.width / 4, y: finalShowLabel2.frame.minY - 20)
            button.addTarget(self, action: #selector(bringView2ToFront), for: .touchUpInside)
        }
        button.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    @objc func bringView1ToFront() {
        view.bringSubviewToFront(finalShowLabel1)
    }
    @objc func bringView2ToFront() {
        view.bringSubviewToFront(finalShowLabel2)
    }
}

