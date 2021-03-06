//
//  rocketClass.swift
//  diagSwiftRealm
//
//

import UIKit

class Rocket {
    
    var diagnosis: String
    var factor: Factor?
    var arcContainer: UIView
    var imageContainer: UIImageView
    var preTestProbability: Double
    var postTestProbability: Double
    var minYbound: CGFloat
    var maxYbound: CGFloat
    var negLRBoolean: Bool = false
    var LR: Double
    var factorSelected: Bool = false
    var arcOpensRight: Bool = true
    var finalXPosition: CGFloat
    var finalYPosition: CGFloat
    var range: CGFloat
    
    init(diagnosis: String, imageContainer: UIImageView, arcContainer: UIView, preTestProbability: Double, arcOpensRight: Bool) {
        self.diagnosis = diagnosis
        self.arcContainer = arcContainer
        self.preTestProbability = preTestProbability
        self.imageContainer = imageContainer
        self.arcOpensRight = arcOpensRight
        
        //Set bounds for movement
        //--------------------
        // Lower on screen, larger Y num
        if arcOpensRight {
            self.maxYbound = 0.8 * (arcContainer.superview?.frame.height ?? arcContainer.frame.height)
        } else {
            self.maxYbound = 0.85 * (arcContainer.superview?.frame.height ?? arcContainer.frame.height)
        }
        
        // Higher on screen
        self.minYbound = 0.2 * (arcContainer.superview?.frame.height ?? arcContainer.frame.height)
        self.range = maxYbound - minYbound
        
        self.LR = 1.0 //default values
        self.postTestProbability = self.preTestProbability
        self.finalXPosition = 10.0
        self.finalYPosition = 10.0
    }
    
    func makePreTestLabel() -> UILabel {
        let label = UILabel()
        
        let labelText = "\(diagnosis)\nPre-test Probability: \n" + String(format:"%.1f", preTestProbability) + "%"
        
        label.text = labelText
        label.backgroundColor = UIColor.white
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 3
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.sizeToFit()
        return label
    }
    
    func containWithInBounds(yvalue: CGFloat) -> CGFloat {
        //Adjusts Y value for touch events to stay within prespecified bounds
        
        var ylocation: CGFloat = 0
        if yvalue < self.minYbound {
            ylocation = self.minYbound
        } else if yvalue > self.maxYbound {
            ylocation = self.maxYbound
        } else {
            ylocation = yvalue
        }
        return ylocation
    }
    
    func setPreTest(yvalue: CGFloat) {
        //Recalculates the preTestProbability value based on height of rocket
        let doubleY: Double = Double(yvalue)
        let range: Double = Double(self.range)
        self.preTestProbability = (range - (doubleY - Double(self.maxYbound))) / (range / 100) - 100
    }
    
    func move(yTouchValue: CGFloat) -> CGFloat {
        
        // USES PYTHAGOREAN THEOREM TO CALCULATE X VALUE ALONG ARC DRAWN BY 'ARCCLASS'
        // ----------------------------------------------------
        // A2 + B2 = C2, SO B = SQRT [ C2 - A2 ]
        
        
        if self.arcOpensRight {
            let ylocation = containWithInBounds(yvalue: yTouchValue)

            // SX AND SY ARE THE FRAME LOCATIONS
            let sxvar = (arcContainer.center.x - arcContainer.frame.width / 2)
            
            // CX IS THE X COMPONENT OF THE CENTER OF THE ARC, WHICH IS DEFINED ELSEWHERE AS 3 * WIDTH OF FRAME
            let cxvar = sxvar + (3.2 * arcContainer.frame.width)
            //let h = arcContainer.frame.height
            let w = arcContainer.frame.width
            
            // TY IS JUST TOUCH Y COMPONENT
            let tyvar = ylocation
            
            let cyvar = (0.8 * arcContainer.frame.height) + (arcContainer.center.y - arcContainer.frame.height/2)
            
            
            let bvar2 = ( pow(3 * w, 2) - pow(cyvar - tyvar, 2) )
            let xlocation = cxvar - bvar2.squareRoot()
            return xlocation
        } else {
            let tyvar = containWithInBounds(yvalue: yTouchValue)
  
            // SX AND SY ARE THE FRAME LOCATIONS
            let sxvar = (arcContainer.center.x - arcContainer.frame.width / 2)
            // CX IS THE X COMPONENT OF THE CENTER OF THE ARC, WHICH IS DEFINED ELSEWHERE AS WIDTH OF FRAME / 2
            // N.B. for this function this is SX **MINUS** 3W, as the arc opens to the left, the center is to the left of the frame
            let w = arcContainer.frame.width
            print("arcCont width", w)
            let cxvar = (arcContainer.frame.width * 2) - sxvar
            let cyvar = (arcContainer.frame.height / 2) + (arcContainer.center.y - arcContainer.frame.height/2)
            let bvar2 = ( pow(2.8*w,2) - pow(cyvar - tyvar, 2) )
            let xlocation = bvar2.squareRoot() - cxvar
            return xlocation
        }
       
    }
    
    func launch() {
        if self.factor == nil {
            print("Can't launch, no factor data")
        } else {
            if negLRBoolean {
                self.LR = self.factor!.negLR
            } else {
                self.LR = self.factor!.posLR
            }
               
            if self.LR == 0.0 {
                self.LR = 0.001
            }
               
            if self.preTestProbability == 0.0 {
                self.preTestProbability = 0.01
            } else if self.preTestProbability >= 100.0 {
                self.preTestProbability = 99.9
            }
           
            let preTestOdds = (self.preTestProbability/100) / (1 - (self.preTestProbability/100))
            let postTestOdds = preTestOdds * self.LR
            self.postTestProbability = (postTestOdds / (1 + postTestOdds))

            let range = Double(self.range)
            let yposition = (range - (self.postTestProbability * range)) + Double(self.minYbound)
            
            let yCG = CGFloat(yposition)
            let xposition = self.move(yTouchValue: yCG)
            self.finalXPosition = xposition
            self.finalYPosition = yCG
        }
        
    }
    
    func createFinalLabel() -> UILabel {
        var stringLR = ""
        let percPostTestProb = self.postTestProbability * 100
        let stringPercPostTestProb = String(format: "%.1f", percPostTestProb)
        let stringPercPreTestProb = String(format: "%.1f", self.preTestProbability)

        stringLR = String(self.LR)
        // Now show labels
        
        let posOrNeg = self.negLRBoolean ? "Negative" : "Positive"
       
        let labelText =
            """
            Finding: \(self.factor!.name!)
            \(posOrNeg) Likelihood Ratio: \(stringLR)
            Pre-test Probability: \(stringPercPreTestProb)%
            Post-test Probability: \(stringPercPostTestProb)%
            \(self.factor!.source!))
            """

        let titleAttrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let titleString = NSMutableAttributedString(string: "\(self.diagnosis)\n", attributes: titleAttrs)
       
        let bodyAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        let normalString = NSMutableAttributedString(string: labelText, attributes: bodyAttrs)
       
        titleString.append(normalString)
        
        let label = UILabel()
        label.attributedText = titleString
        label.backgroundColor = UIColor.systemIndigo
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 7
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.frame = CGRect(x: 10, y: 100, width: 350, height: 170)
        
        return label
    }
    
}
