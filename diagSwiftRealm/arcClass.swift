//
//  arcClass.swift
//  diagSwiftRealm
//
//  Created by Brian Clow on 1/15/20.
//  Copyright © 2020 Brian Clow. All rights reserved.
//

import UIKit

@IBDesignable class CounterView: UIView {
  
  private struct Constants {
    static let lineWidth: CGFloat = 5.0
    static let arcWidth: CGFloat = 5
    
    static var halfOfLineWidth: CGFloat {
      return lineWidth / 2
    }
  }
  
    @IBInspectable var outlineColor: UIColor = UIColor.darkGray
    @IBInspectable var counterColor: UIColor = UIColor.darkGray
  
  override func draw(_ rect: CGRect) {
    // 1
    let center = CGPoint(x: bounds.width*3, y: (bounds.height * 1.25))

    // 2
    let radius: CGFloat = max(bounds.width/2, bounds.height*3)
    let finalRadius = radius/2 - Constants.arcWidth/2

    // 3
    let startAngle: CGFloat = 1.061 * .pi
    let endAngle: CGFloat = 15 * .pi / 12

    // 4
    let path = UIBezierPath(arcCenter: center,
                               radius: finalRadius,
                           startAngle: startAngle,
                             endAngle: endAngle,
                            clockwise: true)

    // 5
    path.lineWidth = Constants.arcWidth
    counterColor.setStroke()
    path.stroke()
  }
}

@IBDesignable class CounterView2: UIView {
  
  private struct Constants {
    static let lineWidth: CGFloat = 5.0
    static let arcWidth: CGFloat = 5
    
    static var halfOfLineWidth: CGFloat {
      return lineWidth / 2
    }
  }
  
    @IBInspectable var outlineColor: UIColor = UIColor.darkGray
    @IBInspectable var counterColor: UIColor = UIColor.darkGray
  
  override func draw(_ rect: CGRect) {
    // 1
    let center = CGPoint(x: 0 - bounds.width / 2, y: (bounds.height/2))

    // 2
    let radius: CGFloat = bounds.height * 1.85
    let finalRadius = radius/2 - Constants.arcWidth/2

    // 3
    let startAngle: CGFloat = 1.89 * .pi
    let endAngle: CGFloat = 2.18 * .pi

    // 4
    let path = UIBezierPath(arcCenter: center,
                               radius: finalRadius,
                           startAngle: startAngle,
                             endAngle: endAngle,
                            clockwise: true)

    // 5
    path.lineWidth = Constants.arcWidth
    counterColor.setStroke()
    path.stroke()
  }
}
