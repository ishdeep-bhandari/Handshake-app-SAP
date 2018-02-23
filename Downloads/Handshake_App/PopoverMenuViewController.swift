//
//  PopoverMenuViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 3/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import EventKit
import CoreData

protocol SavingViewControllerDelegate
{
    func saveText(strText : NSString)
}

class PopoverMenuViewController: UIViewController {

    @IBOutlet weak var EditButton: UIButton!
    
    @IBOutlet weak var DeleteButton: UIButton!
    
  //  @IBOutlet weak var ExportButton: UIButton!
    
    var delegate : SavingViewControllerDelegate?
    
    var eventtitle: String = ""
    var userid: String = ""
    var startdate: String = ""
    var enddate: String = ""
    var eventorgansier: String = ""
    var eventdescription: String = ""
    var eventlocation: String = ""
    var eventattendee: String = ""
    var eventcrm: String = ""
    var eventmip: String = ""
    var eventmgo: String = ""
    var eventsegement: String = ""
    var eventaudience: String = ""
    var eventid: String = ""
    var objectretnew: String = ""
    let calstore = EKEventStore()
    let dateFormatter = NSDateFormatter()
    
    let currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if((self.delegate) != nil)
        {
            delegate?.saveText(eventtitle);
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EditButtonTapped(sender: AnyObject) {
        if (currentUser?.username != self.userid){
            self.displayAlertMessage("Unauthorized Edit", errmessage: "You are not authorized to edit this event")
        }
            
        else{
         self.performSegueWithIdentifier("EditView", sender: self)
        }
    }
    
    @IBAction func DeleteButtonTapped(sender: AnyObject) {
        
        var localeventid: String?
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        if (currentUser?.username != self.userid){
            self.displayAlertMessage("Unauthorized Delete", errmessage: "You are not authorized to delete this event")
        }
        else {
            
            let MyDeleteAlert = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete this event?", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                
                let query = PFQuery(className: "Events")
                query.whereKey("Name", equalTo: self.eventtitle)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    object?.deleteEventually()
                 
                  }
                let push: PFPush = PFPush()
                push.setChannel("Reload")
                push.setMessage("Update \n" + self.eventtitle + " has been permanently removed.")
                push.sendPushInBackground()
             
                let request = NSFetchRequest(entityName: "Events")
                
                request.predicate = NSPredicate(format: "eventid = %@", self.objectretnew)
                
                request.returnsObjectsAsFaults = false
                
                do {
                    
                    let results = try context.executeFetchRequest(request)
                    
                    if results.count > 0 {
                        
                        for result in results as! [NSManagedObject] {
                            
                            localeventid = result.valueForKey("localeventid") as? String
                            
                            if (localeventid == nil){
                                
                            }
                            else{
                            self.calstore.requestAccessToEntityType(.Event) {(granted, error) in
                                if !granted { return }
                                let eventToRemove = self.calstore.eventWithIdentifier(self.eventid)
                                if eventToRemove != nil {
                                    do {
                                        try self.calstore.removeEvent(eventToRemove!, span: .ThisEvent, commit: true)
                                    } catch {
                                        // Display error to user
                                    }
                                }
                            }
                            }
                            context.deleteObject(result)
                            
                        }
                    }
                }
                catch {
                                
                        }

                self.dismissViewControllerAnimated(true, completion: nil)
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
   /* @IBAction func ExportButtonTapped(sender: AnyObject) {
        
        if (self.eventaudience == " " || self.eventtitle == " " || self.eventorgansier == " " || self.eventdescription == " " || self.startdate == " " || self.enddate == " " || self.eventlocation == " " || self.eventmgo == " " || self.eventmip == " " || self.eventcrm == " " || self.eventattendee == " " || self.eventsegement == " "){
            
            self.displayAlertMessage("Empty Fields", errmessage: "All fields must be updated before exporting.")
        }
        else{
        let testFile = FileSaveHelper(fileName: "Data" , fileExtension: .CSV, subDirectory: "SavedFiles", directory: .DocumentDirectory)
        let title = "\"" + self.title! + "\"" + ","
        let crm =   "\"" + self.eventcrm + "\"" + ","
        let loc =   "\"" + self.eventlocation + "\"" + ","
        let attend =  "\"" + self.eventattendee + "\"" + ","
        var description  =  "\"" + self.eventdescription + "\"" + ","
        let organisers =  "\"" + self.eventorgansier + "\"" + ","
        let mip = "\"" + self.eventmip + "\"" + ","
        let mgo = "\"" + self.eventmgo + "\"" + ","
        let start = "\"" + self.startdate + "\"" + ","
        let end = "\"" + self.enddate + "\"" + ","
        let segment = "\"" + self.eventsegement + "\"" + ","
        let audience = "\"" + self.eventaudience + "\"" + ","
        
       
        description = description.stringByReplacingOccurrencesOfString("\n", withString: " ")
        var fileText: String = ""
        var newfileText: String = ""
        print("Directory exists: \(testFile.directoryExists)")
        print("File exists: \(testFile.fileExists)")
        if testFile.fileExists == false{
            fileText = "Event,CRM Code,Location,Attendees,Description,Organisers,MIP(000 EUR),MGO(000 EUR),Start,End,Segment,Audience \n" + title + crm + loc + attend + description + organisers + mip + mgo + start + end + segment + audience
            self.displayAlertMessage("Export Successful", errmessage: "Event Exported Successfully")
            
            do {
                try testFile.saveFile(string: fileText)
            }
            catch {
                print(error)
                let errstr = error as! String
                self.displayAlertMessage("Export Unsuccessful", errmessage: errstr)
            }
        }
        else{
            newfileText = "\n" + title + crm + loc + attend + description + organisers + mip + mgo + start + end + segment + audience
            self.displayAlertMessage("Export Successful", errmessage: "Event Exported Successfully")
            do {
                try testFile.saveFile(string: newfileText)
            }
            catch {
                let errstr = error as! String
                self.displayAlertMessage("Export Unsuccessful", errmessage: errstr)
            }
        }
        }
    }*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "EditView") {
            
            let viewController = segue.destinationViewController as! UINavigationController
            let editview = viewController.topViewController as! AddEventViewController
            editview.titlenew = eventtitle
        }
    }

    @IBAction func SyncButtonTapped(sender: AnyObject) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        calstore.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted { return }
            let appevent = EKEvent(eventStore: self.calstore)
            self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            self.dateFormatter.locale = NSLocale(localeIdentifier: "en_IN")
            let convertedstart = self.dateFormatter.dateFromString(self.startdate)
            let convertedstop = self.dateFormatter.dateFromString(self.enddate)
            appevent.title = self.eventtitle
            appevent.startDate = convertedstart!
            appevent.endDate = convertedstop!
            appevent.location = self.eventlocation
            appevent.calendar = self.calstore.defaultCalendarForNewEvents
            appevent.notes = self.eventdescription
            let eventalarm1 = EKAlarm()
            let eventalarm2 = EKAlarm()
            eventalarm1.relativeOffset = -86400
            eventalarm2.relativeOffset = -3600
            appevent.addAlarm(eventalarm1)
            appevent.addAlarm(eventalarm2)
            self.delay (0.2){
            let MyDeleteAlert = UIAlertController(title: "Add Event", message: "Are you sure you want to add this event to your calendar?", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                
                do {
                    try self.calstore.saveEvent(appevent, span: .ThisEvent, commit: true)
                    
                }
                catch {
                    // Display error to user
                }
                let request = NSFetchRequest(entityName: "Events")
                
                request.predicate = NSPredicate(format: "eventid = %@", self.objectretnew)
                
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
            
            }}
        
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
