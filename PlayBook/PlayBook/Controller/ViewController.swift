//
//  ViewController.swift
//  PlayBook
//
//  Created by Mike Miksch on 12/14/17.
//  Copyright © 2017 Mike MIksch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var lastPoint = CGPoint.zero
    var color : CGColor?
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var canPaint = true
    
    let colors: [CGColor] = [
    UIColor.black.cgColor,
    UIColor.gray.cgColor,
    UIColor.red.cgColor,
    UIColor.orange.cgColor,
    UIColor.yellow.cgColor,
    UIColor.green.cgColor,
    UIColor(red: 0.0/255.0, green: 144.0/255.0, blue: 81.0/255.0, alpha: 1.0).cgColor,
    UIColor.blue.cgColor,
    UIColor.cyan.cgColor,
    UIColor.white.cgColor
    ]

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var pencilBox: UIView!
    @IBOutlet weak var pencilBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var pencilBoxBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        if canPaint {
            UIGraphicsBeginImageContext(view.frame.size)
            let context = UIGraphicsGetCurrentContext()
            tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))

            context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

            context?.setLineCap(.round)
            context?.setLineWidth(brushWidth)
            if let color = color {
                context?.setStrokeColor(color)
            }
            context?.setBlendMode(.normal)

            context?.strokePath()

            tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImageView.alpha = opacity
            UIGraphicsEndImageContext()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height) , blendMode: .normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil
    }

    @IBAction func pencilPressed(_ sender: Any) {
        
        var index = (sender as? UIButton)?.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        color = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    @IBAction func resetPressed(_ sender: Any) {
        mainImageView.image = nil
    }
    @IBAction func togglePressed(_ sender: Any) {
        if canPaint {
            pencilBoxBottomConstraint.constant = pencilBoxHeight.constant + 50
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            pencilBoxBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
        canPaint = !canPaint
    }
    
}

