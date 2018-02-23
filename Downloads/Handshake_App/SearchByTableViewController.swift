//
//  SearchByTableViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 4/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import QuartzCore

class SearchByTableViewController: UITableViewController,UIPopoverPresentationControllerDelegate {
    
    let cellarray = ["Audience","Date","Location","Segment"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.alwaysBounceVertical = false
        
        self.tableView.reloadData()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cellarray.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellbackgroundview = UIView()
        cellbackgroundview.backgroundColor = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 73.0/255.0, alpha: 1)
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.selectedBackgroundView = cellbackgroundview
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)
        cell.textLabel?.text = cellarray[indexPath.row]
        return cell
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "SearchResultsView") {
            
            let viewController = segue.destinationViewController as! SearchResultsTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            viewController.selectedoption = cellarray[indexPath.row]
        }
    }
}
