//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Zachary Rose on 11/20/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let reusableCollectionCellIdentifier = "reusableMemeCollectionCell"
    
    var executeDetailSegue = false
    var executeEditorSegue = false
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Code to set up View Flow
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reusableCollectionCellIdentifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        // Reload Collection each time view Appears
        collectionView!.reloadData()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let row = MemeData.allMemes.count
        return row
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCollectionCellIdentifier, for: indexPath)
        
        let cellImageView = cell.viewWithTag(1) as! UIImageView
        
        cellImageView.image = MemeData.allMemes[indexPath.row].memedImage
        
        return cell
    }
    
    @IBAction func unwindFromEditor(_ segue: UIStoryboardSegue) {
        
        executeEditorSegue = false
        executeDetailSegue = false
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        switch action {
        case #selector(CollectionViewController.unwindFromEditor(_:)):
            let isUnwindResponder = executeEditorSegue || executeDetailSegue
            
            return isUnwindResponder
            
        default:
            return false
        }
    }
    // Function to handle Segue to Editor/Detail VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
            
        case "collectionViewToDetail":
            let sentCell = sender as! UICollectionViewCell
            let sentCellIndexPath = collectionView!.indexPath(for: sentCell)!
            let selectedMeme = sentCellIndexPath.row
            
            let controller = segue.destination as! DetailViewController
            controller.selectedMeme = MemeData.allMemes[selectedMeme]
            
            executeDetailSegue = true
        
        case "collectionViewToEditor":
            executeEditorSegue = true
            
        default:
            print("none")
        }
    }

}
