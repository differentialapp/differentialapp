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
    let center = CGPoint(x: bounds.width*3.2, y: (bounds.height * 0.8))

    // 2
    let radius: CGFloat = bounds.width*3

    // 3
    let startAngle: CGFloat = 0.98 * .pi
    let endAngle: CGFloat = 1.1245 * .pi //1.1111, .12

    // 4
    let path = UIBezierPath(arcCenter: center,
                               radius: radius,
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
    let center = CGPoint(x: 0 - bounds.width * 2, y: (bounds.height/2))

    // 2
    let radius: CGFloat = bounds.width * 2.8

    // 3
    let startAngle: CGFloat = 1.91 * .pi //1.94, .93
    let endAngle: CGFloat = 2.15 * .pi

    // 4
    let path = UIBezierPath(arcCenter: center,
                               radius: radius,
                           startAngle: startAngle,
                             endAngle: endAngle,
                            clockwise: true)

    // 5
    path.lineWidth = Constants.arcWidth
    counterColor.setStroke()
    path.stroke()
  }
}
