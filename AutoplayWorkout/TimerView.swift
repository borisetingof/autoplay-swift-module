//
//  TimerView.swift
//  AutoplayWorkout
//
//  Created by Boris Etingof on 26/11/2014.
//  Copyright (c) 2014 Red Ant. All rights reserved.
//

import UIKit

class TimerView: UIView {

    var percent: Double = 100.0;
    
 
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        //animateArc()
        drawArc()
    }
 
    
    func updateTimer(percent: Double){
        self.percent = 100 - percent
    }
    
    func drawArc(){
        // Drawing code
        var startAngle: Float = Float(2 * M_PI)
        var endAngle: Float = Float(self.percent * 2 * M_PI / 100.0)
        
        // Drawing code
        // Set the radius
        let strokeWidth = 4.0
        let radius = CGFloat((CGFloat(self.frame.size.width) - CGFloat(strokeWidth)) / 2)
        
        // Get the context
        var context = UIGraphicsGetCurrentContext()
        CGContextSetAllowsAntialiasing(context, true);
        
        // Find the middle of the circle
        let center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        
        // Set the stroke color
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        
        // Set the line width
        CGContextSetLineWidth(context, CGFloat(strokeWidth))
        
        // Set the fill color (if you are filling the circle)
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        
        // Rotate the angles so that the inputted angles are intuitive like the clock face: the top is 0 (or 2π), the right is π/2, the bottom is π and the left is 3π/2.
        // In essence, this appears like a unit circle rotated π/2 anti clockwise.
        startAngle = startAngle - Float(M_PI_2)
        endAngle = endAngle - Float(M_PI_2)
        
        //var myPath: CGMutablePathRef = CGPathCreateMutable()
        //CGPathAddArc(path: CGMutablePath!, m: UnsafePointer<CGAffineTransform>, x: CGFloat, y: CGFloat, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)
        //CGPathAddArc(myPath, nil, CGFloat(center.x), CGFloat(center.y), CGFloat(radius), CGFloat(startAngle), CGFloat(endAngle), false)
        
        // Draw the arc around the circle
        CGContextAddArc(context, center.x, center.y, CGFloat(radius), CGFloat(startAngle), CGFloat(endAngle), 0)
        
        // Draw the arc
        CGContextStrokePath(context) // or kCGPathFillStroke to fill and stroke the circle
    }
    
    func animateArc(){
        // set up some values to use in the curve
        let ovalStartAngle = CGFloat(90.01 * M_PI/180)
        let ovalEndAngle = CGFloat(90 * M_PI/180)
        let ovalRect = CGRectMake(97.5, 58.5, 125, 125)
        
        var context = UIGraphicsGetCurrentContext()
        
        // create the bezier path
        let ovalPath = UIBezierPath()
        
        ovalPath.addArcWithCenter(CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)),
            radius: CGRectGetWidth(ovalRect) / 2,
            startAngle: ovalStartAngle,
            endAngle: ovalEndAngle, clockwise: true)
        
        // create an object that represents how the curve
        // should be presented on the screen
        let progressLine = CAShapeLayer()
        progressLine.path = ovalPath.CGPath
        
        progressLine.strokeColor = UIColor.grayColor().CGColor
        progressLine.fillColor = UIColor.clearColor().CGColor
        progressLine.lineWidth = 5.0
        progressLine.lineCap = kCALineCapRound
        progressLine.allowsEdgeAntialiasing = true
        progressLine.shouldRasterize = true
        
        // add the curve to the screen
        self.layer.addSublayer(progressLine)
        
        
        
        // create a basic animation that animates the value 'strokeEnd'
        // from 0.0 to 1.0 over 3.0 seconds
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 3.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        
        // add the animation
        progressLine.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        
        
    }
}
