//
//  DetailTableViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 4/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import EventKit
import CoreData
import EventKit

class DetailTableViewController: UITableViewController,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate,SavingViewControllerDelegate {

    @IBOutlet weak var DetailButton: UIBarButtonItem!
    
    var titleevent: String = ""
    var startdate: String = ""
    var stopdate: String = ""
    var objectidret: String = ""
    var eventloc: String = ""
    var eventorganiser: String  = ""
    var eventdescription: String = ""
    var eventaddedby: String = ""
    var eventattendee: String = ""
    var eventcrm: String = ""
    var eventmip: String = ""
    var eventmgo: String = ""
    var eventsegment: String = ""
    var eventaudience: String  = ""
    let eventtocal = EKEventStore()
    let dateFormatter = NSDateFormatter()
    var eventid: String = " "
    var eventfeedback : String = "0"
    var eventdetails = [String]()
    
    var window: UIWindow?
    
    var activityindicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityindicator = UIActivityIndicatorView(frame: self.view.frame)
        self.activityindicator.center = self.view.center
        self.activityindicator.hidesWhenStopped = true
        view.addSubview(self.activityindicator)
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
                self.title = titleevent
                self.eventdetails.append(eventcrm)
                self.eventdetails.append(eventloc)
                self.eventdetails.append(eventattendee)
                self.eventdetails.append(eventdescription)
                self.eventdetails.append(eventorganiser)
                self.eventdetails.append(eventmgo)
                self.eventdetails.append(eventmip)
                self.eventdetails.append(eventaddedby)
                self.eventdetails.append(eventsegment)
                self.eventdetails.append(eventaudience)
      
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       // self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    @IBAction func BackButtonTapped(sender: AnyObject) {
        
         //   self.popover.dismissPopoverAnimated = true
            self.navigationController!.popViewControllerAnimated(true)
        
    }

    @IBAction func DetailButtonTapped(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PopoverMenuController") as! PopoverMenuViewController
        vc.delegate = self
        vc.eventtitle = titleevent
        vc.userid = eventaddedby
        vc.startdate = startdate
        vc.enddate = stopdate
        vc.eventdescription = description
        vc.eventorgansier = eventorganiser
        vc.eventlocation = eventloc
        vc.eventattendee = eventattendee
        vc.eventcrm = eventcrm
        vc.eventmip = eventmip
        vc.eventmgo = eventmgo
        vc.eventsegement = eventsegment
        vc.eventaudience = eventaudience
        vc.objectretnew = objectidret
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        vc.preferredContentSize = CGSizeMake(400, 150)
        let popover: UIPopoverPresentationController? = vc.popoverPresentationController
        if popover == vc.popoverPresentationController!{
        popover!.backgroundColor = vc.view.backgroundColor
        popover!.barButtonItem = sender as? UIBarButtonItem
        popover!.delegate = self
        presentViewController(vc, animated: true, completion:nil)}
        delay(0.1){
            popover?.passthroughViews = nil
        }
        
    }
    
    func saveText( strText : NSString){
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
  /*  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300.0
    }*/
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 3){
            return 175.0
        }
        else if (indexPath.row == 8 || indexPath.row == 9){
            return 100.0
        }
        return 80.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath:indexPath) as! DetailTableViewCell
        var keys = ["CrmCode:","Location:","Attendees:","Description:","Organisers:","MGO(,000 EUR):","MIP(,000 EUR):","Added By:","Segment:","Audience:"]
        cell.DetailTitle.text = keys[indexPath.row]
        cell.DetailSubtitle.text = self.eventdetails[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        //let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath)

        // Configure the cell...

        
    }
    
    @IBAction func AddToCalendarButtonTapped(sender: AnyObject) {
     let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
     
     let context: NSManagedObjectContext = appDel.managedObjectContext
    
     eventtocal.requestAccessToEntityType(.Event) {(granted, error) in
     if !granted { return }
     let appevent = EKEvent(eventStore: self.eventtocal)
     self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
     self.dateFormatter.locale = NSLocale(localeIdentifier: "en_IN")
     let convertedstart = self.dateFormatter.dateFromString(self.startdate)
     let convertedstop = self.dateFormatter.dateFromString(self.stopdate)
     appevent.title = self.title!
     appevent.startDate = convertedstart!
     appevent.endDate = convertedstop!
     appevent.location = self.eventloc
     appevent.calendar = self.eventtocal.defaultCalendarForNewEvents
     appevent.notes = self.eventdescription
     let eventalarm1 = EKAlarm()
     let eventalarm2 = EKAlarm()
     let eventalarm3 = EKAlarm()
     eventalarm1.relativeOffset = -86400
     eventalarm2.relativeOffset = -3600
     eventalarm3.relativeOffset = -172800
     appevent.addAlarm(eventalarm1)
     appevent.addAlarm(eventalarm2)
     appevent.addAlarm(eventalarm3)
     let MyDeleteAlert = UIAlertController(title: "Add Event", message: "Are you sure you want to add this event to your calendar?", preferredStyle: UIAlertControllerStyle.Alert)
     
     let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
     
     do {
     try self.eventtocal.saveEvent(appevent, span: .ThisEvent, commit: true)
     
        }
          catch {
     // Display error to user
                }
               let request = NSFetchRequest(entityName: "Events")
     
                request.predicate = NSPredicate(format: "eventid = %@", self.objectidret)
     
                request.returnsObjectsAsFaults = false
     
                do {
     
                        let results = try context.executeFetchRequest(request)
     
                        if results.count > 0 {
     
                        for result in results as! [NSManagedObject] {

                        result.setValue(appevent.eventIdentifier, forKey: "localeventid")
        
                         do {
     
                              try context.save()
     
                             } catch {
     
                                      }

     
                            }
     
                    }
                }
            catch{
     
                }
     
        })
     
     let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
     MyDeleteAlert.dismissViewControllerAnimated(true, completion: nil)
     })
     
     MyDeleteAlert.addAction(okAction)
     MyDeleteAlert.addAction(cancelAction)
     
     MyDeleteAlert.view.tintColor = UIColor(red: (22/255.0), green: (41/255.0), blue:(141/255.0), alpha: 1)
     
     self.presentViewController(MyDeleteAlert, animated: true, completion: nil)
     
     MyDeleteAlert.view.tintColor = UIColor(red: (22/255.0), green: (41/255.0), blue:(141/255.0), alpha: 1)
     
     }

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
