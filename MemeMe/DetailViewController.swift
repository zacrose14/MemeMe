//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Zachary Rose on 11/20/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedMeme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = selectedMeme.memedImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueId = segue.identifier else {
            return
        }
        
        switch segueId {
            
        case "detailViewToEditor":
            // segue is to editor's navigation controller; need to reach its child view controller
            let controller = segue.destination as! EditorViewController
            controller.placeholderTop = selectedMeme.topTextField
            controller.placeholderBottom = selectedMeme.bottomTextField
            controller.selectedImage = selectedMeme.originalImage
            
            controller.cameFromDetail = true
            
        default:
            print("unknown segue: \(segueId)")
        }
    }

}
