//
//  Shape.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 19/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit

fileprivate let kType = "type"
fileprivate let kPositionX = "xPosition"
fileprivate let kPositionY = "yPosition"
fileprivate let kRadius = "r"
fileprivate let kColorHex = "color"
fileprivate let kHeight = "height"
fileprivate let kWidth = "width"

class Shape: CAShapeLayer {
    
    var shapeType: ShapeType!
    
    init?(from json: [String: Any]) {
        super.init()
        
        guard
            let type = json[kType] as? String,
            let color = json[kColorHex] as? String,
            let positionX = json[kPositionX] as? CGFloat,
            let positionY = json[kPositionY] as? CGFloat
            else {
                return nil
        }
        
        self.shapeType = ShapeType.from(string: type)
        self.strokeColor = UIColor.clear.cgColor
        self.fillColor = UIColor.fromHex(color).cgColor
        self.position = CGPoint(x: positionX, y: positionY)
        
        if case ShapeType.rectangle = self.shapeType!  {
            guard let width = json[kWidth] as? CGFloat,
                let height = json[kHeight] as? CGFloat else {
                    return nil
            }
            
            let bezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: height))
            self.path = bezierPath.cgPath
        }
        else if case ShapeType.circle = self.shapeType! {
            guard let radius = json[kRadius] as? CGFloat else {
                return nil
            }
            
            let bezierPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
            self.path = bezierPath.cgPath
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    enum ShapeType {
        case circle(r: CGFloat)
        case rectangle
        
        static func from(string: String) -> ShapeType? {
            
            switch string {
            case "circle": return .circle(r: 0.0)
            case "rectangle": return .rectangle
            default: return nil
                
            }
        }
    }
    
}
