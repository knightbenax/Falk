//
//  ImageManager.swift
//  Falk
//
//  Created by Bezaleel Ashefor on 17/04/2023.
//  https://developer.apple.com/documentation/vision/recognizing_text_in_images

import Foundation
import Cocoa
import AppKit
import Vision
import UniformTypeIdentifiers

class ImageManager{
    
    static var shared = ImageManager()
    
    func takeAndProcessScreenshot(screenRect : CGRect){
        let displayID = CGMainDisplayID()
        let screenShot : CGImage? = CGDisplayCreateImage(displayID, rect: screenRect)
        if let screenShot = screenShot {
            let desktopURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
            let destinationURL = desktopURL.appendingPathComponent("my-image.png")
            writeCGImage(screenShot, to: destinationURL)
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                visionRequest(image: screenShot)
            }
        }
    }
    
    private func visionRequest(image: CGImage){
        let requestHandler = VNImageRequestHandler(cgImage: image)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        request.usesLanguageCorrection = true
        request.recognitionLevel = .accurate
        request.minimumTextHeight = 0.02
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        print(recognizedStrings)
        // Process the recognized strings.
        processResults(recognizedStrings)
    }
    
    private func processResults(_ results : [String]){
        let string = results.joined(separator: "\n")
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(string, forType: .string)
    }
    
    @discardableResult private func writeCGImage(_ image: CGImage, to destinationURL: URL) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else { return false }
        CGImageDestinationAddImage(destination, image, nil)
        return CGImageDestinationFinalize(destination)
    }
}
