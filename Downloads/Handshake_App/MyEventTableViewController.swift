//
//  MyEventTableViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 4/7/16.
//  Copyright © 2016 Parse. All rights reserved.
//
import UIKit
import Parse
import CoreGraphics
import EventKit
import MessageUI
import CoreData

class MyEventTableViewController: UITableViewController,MFMailComposeViewControllerDelegate,SavingViewControllerDelegate{
    
    var refresher : UIRefreshControl!
    
    var window: UIWindow?
    
    var activityindicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var usertype: String = ""

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    var details = [TableData]()
    var filtereddetails = [TableData]()
    var sorteddetails = [TableData]()
    let dateFormatter = NSDateFormatter()
    var eventlist: Dictionary<NSDate,Array<TableData>> = [:]
    var sortedsections = [NSDate]()
    var organiserlist : Dictionary<String,String> = [:]
    var eventtocal = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentuserobjectid =  PFUser.currentUser()?.objectId
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: currentuserobjectid!)
        query!.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            
            if error != nil || object == nil {
                self.displayAlertMessage("Error Retrieving Information", errmessage: "There was an error retrieving data. Please try again")
            } else {
                self.usertype = object?.valueForKey("UserType") as! String
            }
        }
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string:"Pull to refresh", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()] )
        refresher.addTarget(self, action: #selector(MyEventTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        self.activityindicator = UIActivityIndicatorView(frame: self.view.frame)
        activityindicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        self.activityindicator.center = self.view.center
        self.activityindicator.hidesWhenStopped = true
        self.activityindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        view.addSubview(self.activityindicator)
        self.activityindicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if #available(iOS 9.0, *) {
            (UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchController.self])).tintColor = UIColor.whiteColor()        } else {
            
        }
        self.tableView.backgroundView = UIView()
        
        self.refresh()
    }
    
    func refresh()
    {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        var localeventid: String?
        
        let currentuser = PFUser.currentUser()
        
        let query = PFQuery(className:"Events")
        var errorMsg = ""
        query.limit = 1000
        query.whereKey("UserId", equalTo: (currentuser?.username)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            self.activityindicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            if error == nil {
                self.details.removeAll(keepCapacity: true)
                self.eventlist.removeAll(keepCapacity: true)
                if let objects = objects {
                    
                    for object in objects {
                        
                        let newdata = TableData(title:(object.valueForKey("Name") as! String), start:(object.valueForKey("Start") as! String), stop: (object.valueForKey("Stop") as! String),segment:(object.valueForKey("Segment") as! String), audience:(object.valueForKey("Audience") as! String), location: (object.valueForKey("Location") as! String), organiser:(object.valueForKey("Organisers") as! String), description:(object.valueForKey("Description") as! String), feedback: (object.valueForKey("Feedback") as! String), feedbackcounter: (object.valueForKey("Feedbackcounter") as! String),mgo: (object.valueForKey("Mgo") as! String), mip: (object.valueForKey("Mip") as! String), userid: (object.valueForKey("UserId") as! String), attendees: (object.valueForKey("Attendees") as! String), crmcode: (object.valueForKey("CrmCode") as! String), objectid: (object.valueForKey("objectId") as! String))
                        
                        self.details.append(newdata)
                        self.dateFormatter.locale = NSLocale(localeIdentifier:"en_IN")
                        self.dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                        let convertedstart = self.dateFormatter.dateFromString(newdata.start)
                        
                        if self.eventlist[convertedstart!] == nil {
                            
                            self.eventlist[convertedstart!] = [newdata]
                        }
                        else {
                            self.eventlist[convertedstart!]?.append(newdata)
                        }
                        
                        let request = NSFetchRequest(entityName: "Events")
                        
                        request.predicate = NSPredicate(format: "eventid = %@", newdata.objectid)
                        
                        request.returnsObjectsAsFaults = false
                        
                        do {
                            
                            let results = try context.executeFetchRequest(request)
                            
                            if results.count > 0 {
                                
                                for result in results as! [NSManagedObject] {
                                    
                                    localeventid = result.valueForKey("localeventid") as? String
                                    print(result.valueForKey("eventid")!)
                                    
                                    if (localeventid == nil){
                                        
                                    }
                                    else{
                                        self.eventtocal.requestAccessToEntityType(.Event) {(granted, error) in
                                            if !granted { return }
                                            let appevent = self.eventtocal.eventWithIdentifier(localeventid!)
                                            self.dateFormatter.locale = NSLocale(localeIdentifier:"en_IN")
                                            self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                                            let convertedstart = self.dateFormatter.dateFromString(newdata.start)
                                            let convertedstop = self.dateFormatter.dateFromString(newdata.stop)
                                            appevent!.title = newdata.title
                                            appevent!.startDate = convertedstart!
                                            appevent!.endDate = convertedstop!
                                            appevent!.location = newdata.location
                                            appevent!.calendar = self.eventtocal.defaultCalendarForNewEvents
                                            appevent!.notes = newdata.description
                                            
                                            do {
                                                try self.eventtocal.saveEvent(appevent!, span: .ThisEvent, commit: true)
                                                
                                            }
                                            catch {
                                                // Display error to user
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                            else{
                                
                                let newUser = NSEntityDescription.insertNewObjectForEntityForName("Events", inManagedObjectContext: context)
                                
                                newUser.setValue(newdata.objectid, forKey: "eventid")
                                
                                // newUser.setValue(" ", forKey: "localeventid")
                                
                                do {
                                    
                                    try context.save()
                                    
                                } catch {
                                    
                                    print("There was a problem!")
                                    
                                }
                            }
                            
                        } catch {
                            
                            print("Fetch Failed")
                        }
                        
                        
                    }
                    
                }
                
                self.sortedsections.removeAll(keepCapacity: true)
                self.sortedsections = self.eventlist.keys.sort(<)
                
            } else {
                
                if  let errorString = error!.userInfo["error"] as? String{
                    
                    errorMsg = errorString
                }
                self.displayAlertMessage("Unable to Log data", errmessage: errorMsg)
            }
            
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
        let newquery = PFUser.query()
        newquery!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.organiserlist.removeAll(keepCapacity: true)
                if let objects = objects {
                    
                    for object in objects {
                        let orgname = object.valueForKey("username") as! String
                        let orgpass = object.valueForKey("email") as! String
                        if self.organiserlist[orgname] == nil{
                            self.organiserlist[orgname] = orgpass
                        }
                        else{
                            self.organiserlist[orgname] = orgpass
                        }
                        
                    }
                }
            }
        }
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    func configuredMailComposeViewController(data:TableData?) -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        
        if Reachability.isConnectedToNetwork() == true {
            
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.navigationBar.tintColor = UIColor(red: 250/255.0, green: 171/255.0, blue: 0, alpha: 1)
            mailComposerVC.setToRecipients([organiserlist[(data?.organiser)!]!])
            mailComposerVC.setSubject((data?.title)!)
            let messageorg = "Owner/s: " + (data?.organiser)! + "\n"
            let messagecrm = "CrmCode:" + (data?.crmcode)! + "\n"
            let messagestart = "Start: " + (data?.start)! + "\n"
            let messagestop = "End: " + (data?.stop)! + "\n"
            let messageloc = "Location: " + (data?.location)! + "\n"
            let messagedes = "Description: " + (data?.description)! + "\n"
            let messagesegment = "Segment: " + (data?.segment)! + "\n"
            let messageaudience = "Audience: " + (data?.audience)! + "\n"
            let messagedata = messageorg + messagecrm + messagestart + messagestop + messageloc + messagedes + messagesegment + messageaudience
            mailComposerVC.setMessageBody(messagedata, isHTML: false)
            
            
        } else {
            self.displayAlertMessage("No Internet Connection", errmessage: "Please check if the device is connected to the internet")
        }
          return mailComposerVC
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    /* override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return self.sortedsections[section]
    }*/
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     /*   if (self.resultSearchController.active){
            return nil
        }
        else{*/
        let headerview  = UIView()
        headerview.backgroundColor = UIColor(red: 32.0/255.0, green: 34.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        let headertext = UILabel()
        headertext.frame = CGRectMake(15, 0, 300, 30)
        headertext.backgroundColor = UIColor.clearColor()
        headertext.textColor = UIColor(red: 250/255.0, green: 171/255.0, blue: 0, alpha: 1)
        self.dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        headertext.text = self.dateFormatter.stringFromDate(self.sortedsections[section])
        headerview.addSubview(headertext)
            return headerview//}
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
       /*if (self.resultSearchController.active){
            return 1
        }
        else{*/
            return sortedsections.count//}
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
     /*   if (self.resultSearchController.active) {
            return self.filtereddetails.count
        }
        else {*/
            return self.eventlist[sortedsections[section]]!.count
        //}
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let data: TableData?
        data = eventlist[sortedsections[indexPath.section]]![indexPath.row]
        let mail  = UITableViewRowAction(style: .Default, title:  "\u{2709}\n Forward") { action, index in
            
            let mailComposeViewController = self.configuredMailComposeViewController(data)
            if MFMailComposeViewController.canSendMail() {
                print(data?.title)
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.displayAlertMessage("Could not send mail", errmessage: "Please try again later.")
            }
        }
        
        mail.backgroundColor = UIColor(red: 12.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1)
        let feedback = UITableViewRowAction(style: .Normal, title:  "\u{2605}\n Feedback") { action, index in
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("FeedBackController") as! FeedbackViewController
            vc.delegate = self
            vc.titleevent = data!.title
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        feedback.backgroundColor = UIColor(red: 12.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1)
        let eventrating = UITableViewRowAction(style: .Normal, title: "TBD\n Rating") { action, index in
            
        }
        eventrating.backgroundColor = UIColor(red: 12.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        let feedbackcounterint = ((data?.feedbackcounter)! as NSString).intValue
        let feedbackcounterstr =  NSString(format: "%d", feedbackcounterint) as String
        if data?.feedbackcounter != "" {
            eventrating.title = (data?.feedback)! + "(" + feedbackcounterstr + ")" + "\n Rating"
        }
        return [eventrating,feedback,mail]
    }
    
    func saveText( strText : NSString){
        
    }
    
    @IBAction func LogoutButtonTapped(sender: AnyObject) {
        
        PFUser.logOut()
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController: UIViewController
        initialViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginController") as! LoginViewController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func AddEventButtonTapped(sender: UIBarButtonItem) {
        if (self.usertype == "Viewer"){
            self.displayAlertMessage("Unauthorised Access", errmessage: "Viewers cannot add new events")
        }
        else{
            self.performSegueWithIdentifier("AddMyEventView", sender: self)}
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellbackgroundview = UIView()
        cellbackgroundview.backgroundColor = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 73.0/255.0, alpha: 1)
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.selectedBackgroundView = cellbackgroundview
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        let data : TableData
        
       /* if (self.resultSearchController.active) {
            data = filtereddetails[indexPath.row]
            
        }
        else {*/
            data = eventlist[sortedsections[indexPath.section]]![indexPath.row]
       // }

        cell.textLabel?.text = data.title
        cell.detailTextLabel?.text = "From: "+data.start+" To: "+data.stop
        
        return cell
    }
    
   /* func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSrechText(searchController.searchBar.text!)
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "MyEventDetailView") {
            
            let viewController = segue.destinationViewController as! DetailTableViewController//UINavigationController
           // let detailview = viewController.topViewController as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let sentdata : TableData
            
           /* if (self.resultSearchController.active) {
                sentdata = filtereddetails[indexPath.row]
            }
            else {*/
                sentdata = eventlist[sortedsections[indexPath.section]]![indexPath.row]
           // }
            viewController.titleevent = sentdata.title
            viewController.startdate = sentdata.start
            viewController.stopdate = sentdata.stop
            viewController.eventloc = sentdata.location
            viewController.eventorganiser = sentdata.organiser
            viewController.eventdescription = sentdata.description
            viewController.eventaddedby = sentdata.userid
            viewController.eventattendee = sentdata.attendees
            viewController.eventcrm = sentdata.crmcode
            viewController.eventmgo = sentdata.mgo
            viewController.eventmip = sentdata.mip
            viewController.eventsegment = sentdata.segment
            viewController.eventaudience = sentdata.audience
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    /*  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }*/
    
    
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
