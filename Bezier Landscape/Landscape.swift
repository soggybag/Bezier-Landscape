//
//  Landscape.swift
//  Bezier Landscape
//
//  Created by mitchell hudson on 7/15/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import Foundation
import SpriteKit

class Landscape: SKNode {
    let shape = SKShapeNode()
    
    override init() {
        super.init()
        
        addChild(shape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
