//
//  GameScene.swift
//  Bezier Landscape
//
//  Created by mitchell hudson on 7/15/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var landscapes = [SKShapeNode]()
    var landscapeWidth: CGFloat!
    var leftLimit: CGFloat!
    var landscapeRight:CGFloat!
    
    var centerY: CGFloat!
    var stepX: CGFloat!
    var stepXhalf: CGFloat!
    var steps: Int = 10
    var lastLandscapeY: CGFloat = 0
    
    
    func scrollLandscapes() {
        for landscape in landscapes {
            landscape.position.x -= 2
            if landscape.position.x < leftLimit {
                // Recycle this landscape and draw a new contour
                landscape.position.x += landscapeRight
                drawBezierLandscape(landscape)
            }
        }
    }
    
    
    
    func drawBezierLandscape(landscape: SKShapeNode) {
        // Create a path. *** I used init(rect) here to draw a box around the landscape for debugging
        // Replace UIbezier(rect:) with UIBezier() to get rid of the rectangle.
        let path = UIBezierPath(rect: view!.frame)
        // set the starting x and y
        var x: CGFloat = 0
        var y: CGFloat = lastLandscapeY
        // Set the starting point
        path.moveToPoint(CGPoint(x: x, y: y))
        // Add points left to right
        for i in 1 ... steps {
            // Set control point 1
            let c1 = CGPoint(x: x + stepXhalf, y: y)
            // Set the x and y for the new point
            x = CGFloat(i) * stepX
            y = CGFloat(arc4random() % 200) - 100 + centerY
            let p = CGPoint(x: x, y: y)
            // Set control point 2
            let c2 = CGPoint(x: x - stepXhalf, y: y)
            
            // Draw a curve to the next point
            path.addCurveToPoint(p, controlPoint1: c1, controlPoint2: c2)
        }
        
        // Save the y value of the last point we'll use this as the starting point for 
        // the next landscape
        lastLandscapeY = y
        // Set the path stroke and fill
        landscape.path = path.CGPath
        let hue = CGFloat(arc4random() % 100) / 100
        landscape.strokeColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        landscape.lineWidth = 4
        // landscape.fillColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
    }
    
    

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Get some numbers we need to draw stuff
        centerY = view.frame.height / 2
        lastLandscapeY = centerY
        
        stepX = view.frame.width / CGFloat(steps)
        stepXhalf = stepX / 2
        
        landscapeWidth = view.frame.width
        leftLimit = 0 - view.frame.width / 1
        
        // Make two "landscapes" these are SKShapeNodes that will
        for i in 0 ..< 2 {
            let landscape = SKShapeNode()
            landscapes.append(landscape)
            addChild(landscape)
            landscape.position.x = CGFloat(i) * landscapeWidth
            drawBezierLandscape(landscape)
        }
        
        landscapeRight = landscapeWidth * CGFloat(landscapes.count)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        scrollLandscapes()
    }
}
