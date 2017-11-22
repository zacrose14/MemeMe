//
//  TableViewController.swift
//  MemeMe
//
//  Created by Zachary Rose on 11/20/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: Variables
    let tableCellReuseIdentifier = "reusableMemeTableCell"
    
    var executeEditorSegue = false
    var executeDetailSegue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reload Table view each time view appears
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let row = MemeData.allMemes.count
        return row
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath)

        let currentMeme = MemeData.allMemes[indexPath.row]
        let cellImageView = cell.viewWithTag(1) as! UIImageView
        cellImageView.image = currentMeme.memedImage
        
        let topText = currentMeme.topTextField
        let bottomText = currentMeme.bottomTextField
        let labelText: String = generateLabelText(topText!, bottomText: bottomText!)
        
        let cellLabel = cell.viewWithTag(2) as! UILabel
        cellLabel.text = labelText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MemeData.allMemes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if MemeData.allMemes.count == 0 {
                let editButton = navigationItem.leftBarButtonItem!
                editButton.title = "Edit"
                editButton.isEnabled = false
                
            }
        } else if editingStyle == .insert {
        }    
    }
    
    func generateLabelText(_ topText: String, bottomText: String) -> String {
        
        let ellipsis = "..."
        
        let maxCharactersAvail = 20
        let halfNumCharactersAvail = maxCharactersAvail / 2
        
        let topTextLength = topText.count
        let bottomTextLength = bottomText.count
        
        var remainingCharactersAvail = maxCharactersAvail
        var labelText = ""
        
        // Top Text
        if topTextLength <= halfNumCharactersAvail {
            labelText += topText
        }
        else {

            let index = topText.index(topText.startIndex, offsetBy: halfNumCharactersAvail)
            labelText += String(topText[..<index])
        }
        
        remainingCharactersAvail -= labelText.count
        
        labelText += ellipsis
        
        // Bottom Text
        if bottomTextLength <= remainingCharactersAvail {
            labelText += bottomText
        }
        else {
            if remainingCharactersAvail <= halfNumCharactersAvail {
                let index = bottomText.index(bottomText.endIndex, offsetBy: -(remainingCharactersAvail))
                labelText += String(bottomText[index...])
            }
            else {
        
                let numCharactersLeftAtFront = remainingCharactersAvail - halfNumCharactersAvail
                let frontIndex = bottomText.index(bottomText.startIndex, offsetBy: numCharactersLeftAtFront)
                labelText += String(bottomText[..<frontIndex])
                
                // Add Ellipsis
                labelText += ellipsis
                remainingCharactersAvail = halfNumCharactersAvail - ellipsis.count
                
                let backIndex = bottomText.index(bottomText.endIndex, offsetBy: -(remainingCharactersAvail))
                labelText += bottomText[backIndex...]
            }
        }
        
        return labelText
    }
    
    // Function to handle Segue to Editor/Detail VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
            
        case "tableViewToDetail":
            let sentCell = sender as! UITableViewCell
            let sentCellIndexPath = tableView!.indexPath(for: sentCell)!
            let selectedMeme = sentCellIndexPath.row
            
            let controller = segue.destination as! DetailViewController
            controller.selectedMeme = MemeData.allMemes[selectedMeme]
            
            executeDetailSegue = true
            
        case "tableViewToEditor":
            executeEditorSegue = true
            
        default:
            print("none")
        }
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

}
