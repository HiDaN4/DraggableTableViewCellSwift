//
//  ViewController.swift
//  DraggableTableViewCellProject
//
//  Created by Dmitry Sokolov on 8/11/15.
//  Copyright (c) 2015 Dmitry Sokolov. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func onDelete(#cell: UITableViewCell)
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {

    @IBOutlet weak private var tableView: UITableView?
    
    let reuseIdentifier = "Cell"
    
    var exampleData = ["Cell 1", "Cell 2", "Cell 3", "Cell 4", "Cell 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exampleData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as! MyCustomCell
        
        cell.delegate = self
        
        cell.textOnSwipeLeft = "Delete"
        cell.textOnSwipeRight = "Repeat"
        cell.colorOnActiveFullSwipeRight = UIColor.greenColor()
        cell.colorOnInactiveSwipeLeft = UIColor.blackColor()
        
        cell.textLabel?.text = self.exampleData[indexPath.row]
        
        return cell
        
        
    }
    
    func onDelete(#cell: UITableViewCell) {
        
        let indexPath = self.tableView?.indexPathForCell(cell)
        if let row = indexPath?.row {
            self.exampleData.removeAtIndex(row)
            
            self.tableView?.beginUpdates()
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView?.endUpdates()
        }
    }

}

