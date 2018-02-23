//
//  AddEventViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 2/24/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import EventKit
import CoreData

class AddEventViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var EventSegment: UITextField!
    
    @IBOutlet var EventAudience: UITextField!
    
    @IBOutlet weak var EventTitle: UITextField!
    
    @IBOutlet weak var EventLocation: UITextField!
    
    @IBOutlet weak var EventCrmCode: UITextField!
    
    @IBOutlet weak var EventOrganisers:UITextField!
    
    @IBOutlet weak var EventAttendee: UITextField!
   
    @IBOutlet weak var EventMgo: UITextField!
    
    @IBOutlet weak var EventMip: UITextField!
    
    @IBOutlet weak var EventDescription: UITextView!

    @IBOutlet weak var EventStartText: UITextField!
  
    @IBOutlet weak var EventStopText: UITextField!

    @IBOutlet weak var DoneButton: UIButton!
    
    @IBOutlet var collectionOftextfields: Array<UITextField>?
    
    var titlenew: String = ""
    var objectretnew: String = ""
    var textviewplaceholder : UILabel!
    var usernames = [String]()
    var audiencedropdown: UIDropDown?
    var organsierdropdown: UIDropDown?
    var segmentdropdown: UIDropDown?
    var eventid : String = " "
    var eventfeedback : String = "0"
    var eventfeedbackcounter : String = "0"
    var segmentfields  = ["BFSI & Telecom","General Business","Key","SCP Others","Strategic Industry"]
    var audiencefields = ["Human Resources","Finance","Marketing","Information Technology"]
    let eventtocal = EKEventStore()
    let dateFormatter = NSDateFormatter()
    
    override func disablesAutomaticKeyboardDismissal() -> Bool {
        return false
    }
    
    @IBAction func EventStartEntry(sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddEventViewController.StartDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        datePickerView.backgroundColor = UIColor(red: 12.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        datePickerView.setValue(UIColor.whiteColor(), forKey: "textColor")
    }
    
    @IBAction func EventStopEntry(sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddEventViewController.StopDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
       datePickerView.backgroundColor = UIColor(red: 12.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        datePickerView.setValue(UIColor.whiteColor(), forKey: "textColor")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audiencedropdown = UIDropDown(textField: EventAudience, dropdownlist: audiencefields)
        segmentdropdown = UIDropDown(textField: EventSegment, dropdownlist: segmentfields)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(AddEventViewController.dismisskeyboard) )
        self.view.addGestureRecognizer(tap)
        
        for i in 0 ..< collectionOftextfields!.count {
            let textfieldimage = UIImageView()
            let image = UIImage(named: "startext.png")
            textfieldimage.image = image
            textfieldimage.frame = CGRect(x: 0,y: 200,width: 8,height: 8)
            var myField = UITextField()
            myField = collectionOftextfields![i]
            myField.leftView = textfieldimage
            myField.leftViewMode = UITextFieldViewMode.Always
        }
        
        let crmpadding = UIView()
        EventCrmCode.leftView = crmpadding
        EventCrmCode.leftViewMode = UITextFieldViewMode.Always
        crmpadding.frame = CGRect(x: 0,y: 0,width: 8, height: 8)
        
        EventTitle.delegate = self
        EventCrmCode.delegate = self
        EventStartText.delegate = self
        EventStopText.delegate = self
        EventLocation.delegate = self
        EventAttendee.delegate = self
        EventMip.delegate = self
        EventMgo.delegate = self
        EventTitle.delegate = self
        EventOrganisers.delegate = self
        EventSegment.delegate = self
        EventAudience.delegate = self
        EventDescription.delegate = self

        textviewplaceholder = UILabel()
        let placeholderfull = "* Short Description"
        let placeholderstar = "*"
        let placeholdertext = " Short Description"
        let range = (placeholderfull as NSString).rangeOfString(placeholderstar)
        let newrange =  (placeholderfull as NSString).rangeOfString(placeholdertext)
        let attributedString = NSMutableAttributedString(string:placeholderfull)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor() , range: range)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: newrange)
        textviewplaceholder.attributedText = attributedString
        textviewplaceholder.sizeToFit()
        EventDescription.addSubview(textviewplaceholder)
        textviewplaceholder.frame.origin = CGPointMake(5, EventDescription.font!.pointSize / 2)
        textviewplaceholder.hidden = !EventDescription.text.isEmpty

        if (titlenew.characters.count == 0)
        {
           
        }else
        {
            
            let query = PFQuery(className: "Events")
            query.whereKey("Name", equalTo: titlenew)
            query.getFirstObjectInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
              
                if error != nil || object == nil {
                    
                    self.displayAlertMessage("Error Retrieving Information", errmessage: "There was an error retrieving data. Please try again")
                }
                else {
                    self.title = "Edit Event"
                    self.textviewplaceholder.hidden = true
                    self.EventTitle.text = object?.valueForKey("Name") as? String
                    self.EventOrganisers.text = object?.valueForKey("Organisers") as? String
                    self.EventDescription.text = object?.valueForKey("Description") as? String
                    self.EventLocation.text = object?.valueForKey("Location") as? String
                    self.EventAttendee.text = object?.valueForKey("Attendees") as? String
                    self.EventCrmCode.text = object?.valueForKey("CrmCode") as? String
                    self.EventMip.text = object?.valueForKey("Mip") as? String
                    self.EventMgo.text = object?.valueForKey("Mgo") as? String
                    self.EventStartText.text = object?.valueForKey("Start") as? String
                    self.EventStopText.text = object?.valueForKey("Stop") as? String
                    self.objectretnew = object?.valueForKey("objectId") as! String
                    self.EventAudience.text = object?.valueForKey("Audience") as? String
                    self.EventSegment.text = object?.valueForKey("Segment") as? String
                    self.eventid = object?.valueForKey("EventId") as! String
                    self.eventfeedback = object?.valueForKey("Feedback") as! String
                    self.eventfeedbackcounter = object?.valueForKey("Feedbackcounter") as! String
                }
            }
        }
        
        let userquery = PFUser.query()
        var errorMsg = ""
        userquery!.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
            
           if error == nil {
                
           if let objects = objects {
                    for object in objects {
                        self.usernames.append(object.valueForKey("username") as! String)
                    }
                }
             self.organsierdropdown = UIDropDown(textField: self.EventOrganisers, dropdownlist: self.usernames)
                
            } else {
                
                if  let errorString = error!.userInfo["error"] as? String{
                    
                    errorMsg = errorString
                }
            self.displayAlertMessage("Unable to Load data", errmessage: errorMsg)
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 2 || textField.tag == 3 || textField.tag == 4{
        }
        else
        {
        let scrollpoint: CGPoint = CGPointMake(0, textField.frame.origin.y)
        ScrollView.setContentOffset(scrollpoint, animated: true)
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 2 || textField.tag == 3 || textField.tag == 4{
        }
        else{
            ScrollView.setContentOffset(CGPoint.zero, animated: true)}
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        let scrollpoint: CGPoint = CGPointMake(0, textView.frame.origin.y)
        ScrollView.setContentOffset(scrollpoint, animated: true)
    }
    func textViewDidEndEditing(textView: UITextView) {
        ScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func dismisskeyboard(){
        EventCrmCode.resignFirstResponder()
        EventTitle.resignFirstResponder()
        EventLocation.resignFirstResponder()
        EventStartText.resignFirstResponder()
        EventStopText.resignFirstResponder()
        EventAttendee.resignFirstResponder()
        EventDescription.resignFirstResponder()
        EventOrganisers.resignFirstResponder()
        EventMgo.resignFirstResponder()
        EventMip.resignFirstResponder()
        EventSegment.resignFirstResponder()
        EventAudience.resignFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        textviewplaceholder.hidden = !textView.text.isEmpty
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    func StartDatePicker(sender: UIDatePicker) {
        let datetimeFormatter = NSDateFormatter()
        datetimeFormatter.locale = NSLocale(localeIdentifier:"en_IN")
        datetimeFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        EventStartText.text = datetimeFormatter.stringFromDate(sender.date)
        
    }

   func StopDatePicker(sender: UIDatePicker) {
    let datetimeFormatter = NSDateFormatter()
    datetimeFormatter.locale = NSLocale(localeIdentifier:"en_IN")
    datetimeFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    EventStopText.text = datetimeFormatter.stringFromDate(sender.date)
    
}
  
    @IBAction func DoneButtonTapped(sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true{
        
        var localeventid: String?
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
      if (EventAttendee.text?.characters.count == 0 || EventTitle.text?.characters.count == 0 || EventOrganisers.text?.characters.count == 0 || EventDescription.text.characters.count == 0 || EventStartText.text?.characters.count == 0 || EventStopText.text?.characters.count == 0 || EventLocation.text?.characters.count == 0 || EventMgo.text?.characters.count == 0 || EventMip.text?.characters.count == 0){
      
           self.displayAlertMessage("Missing Fields", errmessage: "* marked fields are mandatory.")
            
       }else
          {
            if (titlenew.characters.count  == 0)
            {
            let event = PFObject(className: "Events")
            event["Name"] = EventTitle.text
            event["Description"] = EventDescription.text
            event["Start"] = EventStartText.text
            event["Stop"] = EventStopText.text
            event["Organisers"] = EventOrganisers.text
            event["CrmCode"] = EventCrmCode.text
            event["Location"] = EventLocation.text
            event["Attendees"] = EventAttendee.text
            event["Mgo"] = EventMgo.text
            event["Mip"] = EventMip.text
            event["Segment"] = EventSegment.text
            event["Audience"] = EventAudience.text
            event["UserId"] = PFUser.currentUser()!.username
            event["EventId"] = eventid
            event["Feedback"] = eventfeedback
            event["Feedbackcounter"] = eventfeedbackcounter
            event.saveInBackgroundWithBlock{(success, error) -> Void in
                if (success == true){
                   
                }
                else
                {
                    self.displayAlertMessage("Error in creating entry", errmessage: "Please try again")
                }
            }
                let push: PFPush = PFPush()
                push.setChannel("Reload")
                push.setMessage("Update \n" + self.EventTitle.text! + " added" + "\n" + "with Organsiers: " + self.EventOrganisers.text!)
                push.sendPushInBackground()
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    
            else{ let query = PFQuery(className:"Events")
                
                query.getObjectInBackgroundWithId(objectretnew) {
                    (event: PFObject?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else if let event = event{
                        event["Name"] = self.EventTitle.text
                        event["Description"] = self.EventDescription.text
                        event["Start"] = self.EventStartText.text
                        event["Stop"] = self.EventStopText.text
                        event["Organisers"] = self.EventOrganisers.text
                        event["CrmCode"] = self.EventCrmCode.text
                        event["Location"] = self.EventLocation.text
                        event["Attendees"] = self.EventAttendee.text
                        event["Mgo"] = self.EventMgo.text
                        event["Mip"] = self.EventMip.text
                        event["Segment"] = self.EventSegment.text
                        event["Audience"] = self.EventAudience.text
                        event["UserId"] = PFUser.currentUser()!.username
                        event["EventId"] = self.eventid
                        event["Feedback"] = self.eventfeedback
                        event["Feedbackcounter"] = self.eventfeedbackcounter
                        
                        let request = NSFetchRequest(entityName: "Events")
                        
                        request.predicate = NSPredicate(format: "eventid = %@", self.objectretnew)
                        
                        request.returnsObjectsAsFaults = false
                        
                        do {
                            
                            let results = try context.executeFetchRequest(request)
                            
                            if results.count > 0 {
                                
                                for result in results as! [NSManagedObject] {
                                    
                                  localeventid = result.valueForKey("localeventid") as? String
                                }
                            }
                        }
                            catch{
                                print("error")
                            }
                            
                       if (localeventid == nil){
                            
                                }
                        else{
                        self.eventtocal.requestAccessToEntityType(.Event) {(granted, error) in
                            if !granted { return }
                            let appevent = self.eventtocal.eventWithIdentifier(localeventid!)
                            self.dateFormatter.locale = NSLocale(localeIdentifier:"en_IN")
                            self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                            let convertedstart = self.dateFormatter.dateFromString(self.EventStartText.text!)
                            let convertedstop = self.dateFormatter.dateFromString(self.EventStopText.text!)
                          
                         
                            appevent!.title = self.EventTitle.text!
                            appevent!.startDate = convertedstart!
                            appevent!.endDate = convertedstop!
                            appevent!.location = self.EventLocation.text
                            appevent!.calendar = self.eventtocal.defaultCalendarForNewEvents
                            appevent!.notes = self.EventDescription.text
                            
                            do {
                                try self.eventtocal.saveEvent(appevent!, span: .ThisEvent, commit: true)
                                
                            }
                            catch {
                                // Display error to user
                            }
                            }
                        
                        }
                        event.saveInBackgroundWithBlock{(success, error) -> Void in
                            if (success == true){
                                let push: PFPush = PFPush()
                                push.setChannel("Reload")
                                push.setMessage("Update \n" + self.EventTitle.text! + " edited" + "\n" + "with Organsiers: " + self.EventOrganisers.text!)
                                push.sendPushInBackground()
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            else
                            {
                                self.displayAlertMessage("Error during Edit", errmessage: "Please try again")
                            }
                            }
                            
                        
                    }
                  }
               }
            }
        }
        else{
            self.displayAlertMessage("No Internet Connection", errmessage: "Please check if the device is connected to the internet") 
        }
}

        @IBAction func CancelButtonTapped(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}


    

    




