//
//  WindowManager.swift
//  Falk
//
//  Created by Bezaleel Ashefor on 17/04/2023.
//

import Foundation
import Cocoa
import AppKit

class WindowManager{
    
    
    var dialogController : NSWindowController!
    static var shared = WindowManager()
    private var overlayWindow : NSWindow!
    private var cursor : NSCursor!
    
    private func createOverlayWindowForSnip() {
        cursor = NSCursor.crosshair
        cursor.push()
        let windowRect = NSScreen.main?.frame ?? .zero
        overlayWindow = NSWindow(contentRect: windowRect,
                                 styleMask: .borderless,
                                 backing: .buffered,
                                 defer: false,
                                 screen: NSScreen.main)
        overlayWindow.isReleasedWhenClosed = false
        overlayWindow.level = .modalPanel
        overlayWindow.backgroundColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        overlayWindow.alphaValue = 0.5
        overlayWindow.isOpaque = false
        overlayWindow.ignoresMouseEvents = false
        overlayWindow.makeKeyAndOrderFront(nil)
    }
    
    
    
    func showDialogView(){
        let mainStoryboard = NSStoryboard.init(name: NSStoryboard.Name("Main"), bundle: nil)
        dialogController = mainStoryboard.instantiateController(withIdentifier: "MainWindowController") as? NSWindowController
        
        dialogController.window?.styleMask = .borderless
        dialogController.window?.isOpaque = false
        dialogController.window?.level = .modalPanel
        dialogController.window?.backgroundColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        let windowFrame = dialogController.window?.frame ?? CGRect.zero
        let mainScreenFrame = NSScreen.main?.visibleFrame ?? CGRect.zero
        var pos = NSPoint()
           pos.x = mainScreenFrame.origin.x + mainScreenFrame.size.width - windowFrame.size.width - 10
           pos.y = mainScreenFrame.origin.y + mainScreenFrame.size.height - windowFrame.size.height - 5
        dialogController.window?.setFrameOrigin(pos)
        
        dialogController.window?.makeKeyAndOrderFront(self)
    }
    
    func closeDialogView(){
        dialogController?.close()
    }
    
    
    
    
    
    
}
