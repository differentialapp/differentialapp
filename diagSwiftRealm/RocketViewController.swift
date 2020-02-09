//
//  SecondViewController.swift
//  diagSwiftRealm
//
//

import Foundation
import UIKit

class RocketViewController: UIViewController {
    
    @IBOutlet weak var shipPic1: UIImageView!
    @IBOutlet weak var shipPic2: UIImageView!
    @IBOutlet weak var arcView: DrawArcView1!
    @IBOutlet weak var arcView2: DrawArcView2!
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
        setUpRockets()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func setUpRockets() {
        if  selectedDiagnoses.count == 1 {
            //Create rocket object(s), place along arc
            rocket1 = Rocket(diagnosis: selectedDiagnoses[0], imageContainer: shipPic1, arcContainer: arcView, preTestProbability: 10.0, arcOpensRight: true)
            let x1 = rocket1!.move(yTouchValue: rocket1!.maxYbound)
            shipPic1.center = CGPoint(x: x1, y: rocket1!.maxYbound)
            view.addSubview(shipPic1)
            view.bringSubviewToFront(arcView)
            view.bringSubviewToFront(shipPic1)
        } else if selectedDiagnoses.count == 2 {
            
            //This just turns second rocket to point up
            let angle = Double.pi / 3
            shipPic2.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            
            //Create rocket object(s)
            rocket1 = Rocket(diagnosis: selectedDiagnoses[0], imageContainer: shipPic1, arcContainer: arcView, preTestProbability: 1.0, arcOpensRight: true)
            rocket2 = Rocket(diagnosis: selectedDiagnoses[1], imageContainer: shipPic2, arcContainer: arcView2, preTestProbability: 1.0, arcOpensRight: false)

            
            //Place ships along arc
            let x1 = rocket1!.move(yTouchValue: rocket1!.maxYbound)
            shipPic1.center = CGPoint(x: x1, y: rocket1!.maxYbound)

            let y2 = rocket2?.maxYbound
            let x2 = rocket2!.move(yTouchValue: y2!)
            rocket2?.setPreTest(yvalue: y2!)
            shipPic2.center = CGPoint(x: x2, y: y2!)
            view.addSubview(shipPic1)
            view.bringSubviewToFront(arcView)
            view.bringSubviewToFront(shipPic1)
            view.addSubview(shipPic2)
            view.bringSubviewToFront(arcView2)
            view.bringSubviewToFront(shipPic2)
        }
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
                    
                    print("2 xloc", xlocation!)
                    print("2 yloc", ylocation!)
                    shipPic2.center = CGPoint(x: xlocation!, y: ylocation!)
                    
                    //Calculate PreTest Prob
                    rocket2?.setPreTest(yvalue: ylocation!)
                    
                    //Create label to temporarily display pre-test probability
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
                    
                    //Create label to temporarily display pre-test probability
                    preTestLabel = rocket1?.makePreTestLabel() ?? UILabel()
                    preTestLabel.center = CGPoint(x: xlocation! + 60, y: ylocation! - 60)
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
                    print("2 xloc", xlocation!)
                    print("2 yloc", ylocation!)
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
                    preTestLabel.center = CGPoint(x: xlocation! + 60, y: ylocation! - 60)
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
    
    // IBACTIONS: Change between different modes (from pre test selection
    // to test selection)
    // -----------------------------------------------------------
    
    @IBAction func changeToSelectionMode(_ sender: UIButton) {
        readyForSelection = true
        topDirectiveLabel.text = "Now tap each ship to select a test / exam finding"
        sender.isHidden = true
        sender.isUserInteractionEnabled = false
        
    }
    
    // Dismisses test selection modal
    
    @IBAction func backUpTo2(_ sender: UIStoryboardSegue) {
        launchButton.setTitle("Launch!", for: .normal)
        launchButton.frame = CGRect(x: 10, y: 100, width: 200, height: 90)
        launchButton.backgroundColor = UIColor.systemIndigo
        launchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        launchButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
        launchButton.addTarget(self, action: #selector(launchAllRockets), for: .touchUpInside)
        view.addSubview(launchButton)
    }
    
    // SEGUE PREP (for transition to test selection modal)
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
            rocket1?.launch()
            animateAlongMyPath(image: shipPic1, rocket: rocket1!)
            finalShowLabel1 = (rocket1?.createFinalLabel())!
            finalShowLabel1.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
            finalShowButton1 = createNumberButton(forWhat: "showLabel1")
            view.addSubview(finalShowLabel1)
            view.addSubview(finalShowButton1!)
        }
        if rocket2?.factorSelected ?? false {
            rocket2?.launch()
            animateAlongMyPath(image: shipPic2, rocket: rocket2!)
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
    
    func animateAlongMyPath(image: UIImageView, rocket: Rocket) {
        
        //Divide animation path into 5 segments, as have to move along Bezier curve
        let divisions: Double = 5
        let intDiv = Int(divisions)
        let startY: Double = Double(image.center.y)
        let endY: Double = Double(rocket.finalYPosition)
        let range: Double = Double(rocket.range)
        
        let deltaY = ( startY - endY ) / divisions
        let deltaYCG = CGFloat(deltaY)
        var newY: CGFloat =  CGFloat(startY)
        var timeSum = 0.0
        let timeTotal = (deltaY / range) * 3.0
        let timeDelta = timeTotal / divisions  // For linear divide by divisions
        
        for _ in 1...intDiv {
            newY = newY - deltaYCG
            UIView.animate(withDuration: timeDelta, delay: timeSum, options: .curveLinear, animations: {
                image.center = CGPoint(x: rocket.move(yTouchValue: newY), y: newY)
            }, completion: nil)
            //timeDelta = timeDelta / 3
            timeSum = timeSum + timeDelta
        }
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

