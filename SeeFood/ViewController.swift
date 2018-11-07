//
//  ViewController.swift
//  SeeFood
//
//  Created by Phi Hoang Huy on 10/29/18.
//  Copyright © 2018 Phi Hoang Huy. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickImage
            guard let ciimage = CIImage(image: userPickImage) else {
                fatalError("Coudln't convert user image to CIImage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func detect(image: CIImage) {
       guard let model = try? VNCoreMLModel(for: Inceptionv3().model)
        else {
            fatalError("Loading CoreML model failes.")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            print(result)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do
        {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

