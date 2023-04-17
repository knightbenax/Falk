//
//  RectRoundingBox.swift
//  Falk
//
//  Created by Bezaleel Ashefor on 17/04/2023.
//

import Foundation
import Cocoa
import QuartzCore

class RectRoundingBox: NSView {
    
    //MARK:Properties
    private var startPoint : NSPoint!
    private var shapeLayer : CAShapeLayer!
    private var screenManager: ScreenManager!
    private var cursor : NSCursor!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //or customized constructor/ init
    init(frame frameRect: NSRect, screenManager: ScreenManager) {
        super.init(frame:frameRect)
        self.screenManager = screenManager
        let trackingArea = NSTrackingArea(rect: self.frame, options: [NSTrackingArea.Options.activeAlways , NSTrackingArea.Options.mouseEnteredAndExited], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        cursor = NSCursor.crosshair
        cursor.push()
        super.mouseEntered(with: event)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        cursor.pop()
    }
    
    override func mouseDown(with event: NSEvent) {
        
        self.startPoint = self.convert(event.locationInWindow, from: nil)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = NSColor.black.withAlphaComponent(0.3).cgColor
        shapeLayer.strokeColor = NSColor.white.cgColor
        //shapeLayer.lineDashPattern = [10, 5]
        self.layer?.addSublayer(shapeLayer)
        
        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.duration = 0.75
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = 15.0
        dashAnimation.repeatCount = .infinity
        //shapeLayer.add(dashAnimation, forKey: "linePhase")
    }
    
    override func mouseDragged(with event: NSEvent) {
        let point : NSPoint = self.convert(event.locationInWindow, from: nil)
        let path = CGMutablePath()
        path.move(to: self.startPoint)
        path.addLine(to: NSPoint(x: self.startPoint.x, y: point.y))
        path.addLine(to: point)
        path.addLine(to: NSPoint(x:point.x,y:self.startPoint.y))
        path.closeSubpath()
        self.shapeLayer.path = path
    }
    
    override var isFlipped : Bool {
        get {
            return true
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        // save the rect before we remove the shapelayer. If we do it before, the shapelayer shows in the screenshot
        let rect = shapeLayer.path?.boundingBox ?? CGRect.zero
        self.shapeLayer.removeFromSuperlayer()
        self.shapeLayer = nil
        print(self.frame)
        screenManager.updateRect(shapeLayerRect: rect)
    }
    
}
