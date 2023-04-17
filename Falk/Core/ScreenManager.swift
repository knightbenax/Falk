//
//  ScreenManager.swift
//  Falk
//
//  Created by Bezaleel Ashefor on 17/04/2023.
//
//  This manages all screen operations, putting an overlay on the main screen where the mouse is and then drawing
//  the snipping area.

import Foundation
import Cocoa
import AppKit

class ScreenManager{
    
    static var shared = ScreenManager()
    public typealias ScreenSnipBlock = (_ overlayWindow : NSWindow, _ snipRect : CGRect) -> Void
    private var screenSnipBlock : ScreenSnipBlock?
    private var shapeLayerRect : CGRect!
    private var overlayWindow : NSWindow!
    
    func snipScreen(snipHandler: @escaping ScreenSnipBlock){
        self.screenSnipBlock = snipHandler
        createOverlayWindowForSnip()
    }
    
    private func createOverlayWindowForSnip() {
        
        let windowRect = NSScreen.main?.frame ?? .zero
        overlayWindow = NSWindow(contentRect: windowRect,
                                 styleMask: .borderless,
                                 backing: .buffered,
                                 defer: false,
                                 screen: NSScreen.main)
        let rectRoundingBox = RectRoundingBox(frame: windowRect, screenManager: self)
        overlayWindow.contentView = rectRoundingBox
        overlayWindow.isReleasedWhenClosed = false
        overlayWindow.level = .modalPanel
        overlayWindow.backgroundColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        overlayWindow.alphaValue = 0.5
        overlayWindow.isOpaque = false
        overlayWindow.ignoresMouseEvents = false
        overlayWindow.makeKeyAndOrderFront(nil)
    }
    
    func updateRect(shapeLayerRect: CGRect){
        let rect = self.overlayWindow.convertToScreen(shapeLayerRect)
        screenSnipBlock?(overlayWindow, rect)
    }
    
    
}
