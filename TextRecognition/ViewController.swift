//
//  ViewController.swift
//  TextRecognition
//
//  Created by Minaam Ahmed Awan on 28/06/2021.
//

import Vision
import UIKit

class ViewController: UIViewController {
    
    // IBOutlets:
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ImageView Props:
        imageView.image = UIImage(named: "Test")
        imageView.contentMode = .scaleAspectFit
        
        recogniseText(image: imageView.image)
    }
    
    private func recogniseText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        
        // Handler:
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request:
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n")
            
            DispatchQueue.main.async {
                self?.textView.text = text
            }
        }
        request.usesLanguageCorrection = true
        
        
        // Process Request:
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
}

