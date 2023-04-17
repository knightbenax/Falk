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
    
    
    static var shared = WindowManager()
    private var overlayWindow : NSWindow!
    
    private func createOverlayWindowForSnip() {
        
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
        let dialogController = mainStoryboard.instantiateController(withIdentifier: "MainWindowController") as! NSWindowController
        dialogController.window?.styleMask = .borderless
        dialogController.window?.isOpaque = false
        dialogController.window?.level = .modalPanel
        dialogController.window?.backgroundColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        dialogController.window?.setFrameOrigin(NSPoint(x: 0, y: 0))
        dialogController.window?.makeKeyAndOrderFront(self)
    }
    
}
