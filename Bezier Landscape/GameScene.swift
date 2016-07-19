//
//  GameScene.swift
//  Bezier Landscape
//
//  Created by mitchell hudson on 7/15/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var ball: SKShapeNode!
    var ballRolling = false
    
    var landscapes = [SKShapeNode]()
    var landscapeWidth: CGFloat!
    var leftLimit: CGFloat!
    var landscapeRight:CGFloat!
    
    var centerY: CGFloat!
    var stepX: CGFloat!
    var stepXhalf: CGFloat!
    
    // Set the width of a landscape section
    var sectionWidth: CGFloat = 10000
    // Set the number of curves drawn into each section
    var steps: Int = 80
    // Set the amount of
    var slopeRange: UInt32 = 160
    var slopeMinChange: CGFloat = 40
    var slopeRangeCenter: CGFloat = 80
    
    var lastLandscapeY: CGFloat = 0
    
    var lastUpdateTimeInterval: CFTimeInterval = 0
    
    var cameraNode: SKCameraNode!
    
    func scrollLandscapes(deltaTime: CFTimeInterval) {
        for landscape in landscapes {
            // Use
            landscape.position.x -= 40 * CGFloat(deltaTime)
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
        // let path = UIBezierPath(rect: view!.frame)
        let path = UIBezierPath()
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
            // y = CGFloat(arc4random() % 100) - 100 + centerY
            y -= (CGFloat(arc4random() % slopeRange) + slopeMinChange) - slopeRangeCenter
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
        landscape.strokeColor = UIColor(hue: hue, saturation: 1, brightness: 0.5, alpha: 1)
        landscape.lineWidth = 8
        // landscape.fillColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        
        landscape.physicsBody = SKPhysicsBody(edgeChainFromPath: path.CGPath)
        landscape.physicsBody?.dynamic = false
        landscape.physicsBody?.friction = 0
    }
    
    

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        cameraNode = SKCameraNode()
        addChild(cameraNode)
        camera = cameraNode
        
        let ballSize = CGSize(width: 30, height: 30)
        ball = SKShapeNode(ellipseOfSize: ballSize)
        ball.fillColor = UIColor(white: 1, alpha: 0.3)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        
        // ball.physicsBody?.linearDamping = 0.8
        ball.physicsBody?.friction = 0
        ball.physicsBody?.allowsRotation = false
        
        ball.position.x = view.frame.width / 2
        ball.position.y = view.frame.height - 100
        addChild(ball)
        
        /*
        let b = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 10, height: 10))
        b.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 10, height: 10))
        b.physicsBody?.dynamic = false
        addChild(b)
        
        let anchor = CGPoint(x: view.frame.width / 2, y: 50)
        b.position = anchor
        let vector = CGVector(dx: 0, dy: view.frame.height - 100)
        let joint = SKPhysicsJointSliding.jointWithBodyA(ball.physicsBody!, bodyB: b.physicsBody!, anchor: anchor, axis: vector)
        physicsWorld.addJoint(joint)
        */
        
        // Get some numbers we need to draw stuff
        centerY = view.frame.height / 2
        lastLandscapeY = centerY
        
        stepX = sectionWidth / CGFloat(steps)
        stepXhalf = stepX / 2
        
        landscapeWidth = sectionWidth
        leftLimit = -landscapeWidth
        
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
        // let touch = touches.first
        ballRolling = true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        ballRolling = false
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var timeSinceLast: CFTimeInterval = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if timeSinceLast > 1 {
            timeSinceLast = 1.0 / 60.0
            lastUpdateTimeInterval = currentTime
        }
        // scrollLandscapes(timeSinceLast)
        
        
        if ballRolling {
            // ball.physicsBody?.applyTorque(-1000)
            ball.physicsBody?.applyForce(CGVector(dx: 15, dy: -21))
            // print(ball.physicsBody?.angularVelocity)
        }
 
        
        cameraNode.position = ball.position
        
    }
}
