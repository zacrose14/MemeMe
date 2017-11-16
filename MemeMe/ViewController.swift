//
//  ViewController.swift
//  MemeMe
//
//  Created by Zachary Rose on 11/16/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    
    // MARK: Variables
    var info: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func viewWillAppear() {
        //cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // Action from button
    @IBAction func pickImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    
    }
    
    // Camera button to take picture
    @IBAction func cameraButton(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    // Function to pick image and load to screen.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
}
