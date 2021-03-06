//
//  EditorViewController.swift
//  MemeMe
//
//  Created by Zachary Rose on 11/16/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // MARK: Variables
    var selectedImage: UIImage!
    var memedImage: UIImage!
    var placeholderTop = "TOP"
    var placeholderBottom = "BOTTOM"
    var cameFromDetail = false
    
    //MARK: Set VC Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        setDefaultFontAttributes(topTextField)
        setDefaultFontAttributes(bottomTextField)
        
        topTextField.text = placeholderTop
        bottomTextField.text = placeholderBottom
        
        if let anImage = selectedImage {
            imagePickerView.image = anImage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotifications()
        
        // Enable/Disable Buttons based on sources available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        shareButton.isEnabled = (imagePickerView.image != nil) ? true : false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Set text attributes.
    
    func setDefaultFontAttributes(_ textField: UITextField) {
        
        let memeTextCenter = NSMutableParagraphStyle()
        memeTextCenter.alignment = NSTextAlignment.center
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue : UIColor.white ,
            NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSAttributedStringKey.strokeWidth.rawValue : -3.0,
            NSAttributedStringKey.paragraphStyle.rawValue : memeTextCenter
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.adjustsFontSizeToFitWidth = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text! as NSString
        let capitalizedText = currentText.replacingCharacters(in: range, with: string.uppercased())
        
        textField.text = capitalizedText
        
        return false
    }
    
    func generateMemedImage() -> UIImage {
        
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    func saveMeme() {
        // Create the meme
        let meme = Meme.init(
            topTextField: topTextField.text,
            bottomTextField: bottomTextField.text,
            originalImage: imagePickerView.image,
            memedImage: memedImage)
        
        // Save Meme to Array
        MemeData.allMemes.append(meme)
    }
    
    // MARK: Keyboard custom functions
    @objc func keyboardWillShow(_ notification:Notification) {
        
        // Only move keyboard up if typing in bottom text field
        if bottomTextField.isFirstResponder {
            let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
            self.view.frame.origin.y -= (keyboardSize?.cgRectValue.height)!
        }
    }
   
    @objc func keyboardWillHide(_ notification:Notification) {
        
        // Again, only run if using bottom text field
        if(bottomTextField.isFirstResponder) {
            self.view.frame.origin.y = 0
        }
    }
    
    // function to get keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo

        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Subscribe to Keyboard Notifications
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Unsubscribe from Keyboard Notifications
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Remove keyboard when user taps outside of text box.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func dismissKeyboard(_ textField: UITextField) {
        
        // dismiss the keyboard
        textField.endEditing(true)
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismissKeyboard(textField)
        return true
    }
    
    
    // Single Function to handle both image picker functions
    @IBAction func pickMemeImage(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        var sourceType: UIImagePickerControllerSourceType!
        
        switch sender {
            
        case albumButton:
            sourceType = .photoLibrary
            
        case cameraButton:
            sourceType = .camera
            
        default:
            print("None")
            return
        }
        
        imagePicker.sourceType = sourceType
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Share button action
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
        memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) -> Void in
            
            if completed {
                self.saveMeme()
                
                self.performSegue(withIdentifier: "unwindFromEditor", sender: self)
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Cancel button action
    @IBAction func cancelButtonTapped(_ sender: Any) {
    
        if cameFromDetail == true {
            dismiss(animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unwindFromEditor", sender: self)
            print("test")
        }
    }
    
    // Function to pick image and load to screen.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
    }

}
