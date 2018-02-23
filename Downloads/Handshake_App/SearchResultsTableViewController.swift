//
//  SearchResultsTableViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 4/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import MessageUI
import QuartzCore

class SearchResultsTableViewController: UITableViewController,UIPopoverPresentationControllerDelegate,UISearchResultsUpdating,UIPickerViewDelegate,MFMailComposeViewControllerDelegate,SavingViewControllerDelegate{

    var resultSearchController = UISearchController(searchResultsController: nil)
    
    var PickerView: UIPickerView?
    
    var DatePickerView: UIDatePicker?
    
    var details = [TableData]()
    var filtereddetails = [TableData]()
    var eventlist: Dictionary<NSDate,Array<TableData>> = [:]
    var sortedsections = [NSDate]()
    var selectedoption: String = " "
    var PickerData: [String] = [" "]
    var organisers: [String] = [" "]
    var organiserlist : Dictionary<String,String> = [:]
    let dateFormatter = NSDateFormatter()
    
    func filterContentForSrechText(searchText: String,scope: String = "All"){
   
        switch selectedoption {
            
        case "Audience":   filtereddetails = details.filter{ data in
            return data.audience.lowercaseString.containsString(searchText.lowercaseString)        }
            break
            
        case "Segment":  filtereddetails = details.filter{ data in
            return data.segment.lowercaseString.containsString(searchText.lowercaseString)        }
            break
            
        case "Location": filtereddetails = details.filter{ data in
            return data.location.lowercaseString.containsString(searchText.lowercaseString)}
            break
            
        default: filtereddetails = details.filter{ data in
            return data.start.lowercaseString.containsString(searchText.lowercaseString) || data.stop.lowercaseString.containsString(searchText.lowercaseString)}
            break
        }
        tableView.reloadData()
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedoption

        switch selectedoption {
            
        case "Audience":  PickerData = ["Finance","Human Resources","Information Technology","Marketing"]
            break
            
        case "Segment":  PickerData  = ["BFSI & Telecom","General Business","Key","SCP Others","Strategic Industry"]
            break
            
        case "Location": PickerData = ["Bangalore","Bangladesh","Chennai","Coimbatore","Colombo","Delhi","Dhaka","Hyderabad","Jaipur","Jamshedpur","Mumbai","Orlando","Pan India ","Pune","TBD","Trivandrum"]
             break
            
        default: break
        }
    
        PickerView = UIPickerView()
        PickerView?.delegate = self
        PickerView?.backgroundColor = UIColor(red: 12.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.barTintColor = UIColor(red: 32.0/255.0, green: 34.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        toolBar.tintColor = UIColor(red: 250/255.0, green: 171/255.0, blue: 0, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchResultsTableViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchResultsTableViewController.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
       
        DatePickerView = UIDatePicker()
        DatePickerView!.datePickerMode = UIDatePickerMode.Date
        DatePickerView?.backgroundColor = UIColor(red: 12.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        DatePickerView?.setValue(UIColor.whiteColor(), forKey: "textColor")
        DatePickerView!.addTarget(self, action: #selector(SearchResultsTableViewController.SearchDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)

        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchBar.setShowsCancelButton(false, animated: false)
        resultSearchController.definesPresentationContext = true
        let searchtextfield = resultSearchController.searchBar.valueForKey("searchField") as? UITextField
        searchtextfield?.textColor = UIColor.whiteColor()
        if (selectedoption == "Date"){
            searchtextfield?.inputView = DatePickerView
        }
        else{
            searchtextfield?.inputView = PickerView}
        searchtextfield?.inputAccessoryView = toolBar
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        tableView.tableHeaderView = resultSearchController.searchBar
        
        self.tableView.backgroundView = UIView()
        
        refresh()
        
    }
    func SearchDatePicker(sender: UIDatePicker) {
        
        let datetimeFormatter = NSDateFormatter()
        datetimeFormatter.locale = NSLocale(localeIdentifier:"en_IN")
        datetimeFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let searchtextfield = resultSearchController.searchBar.valueForKey("searchField") as? UITextField
        searchtextfield!.text = datetimeFormatter.stringFromDate(sender.date)
        
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
        return mailComposerVC    }
    
    override func viewDidAppear(animated: Bool) {
       PickerView?.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(colorPicker: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return PickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let attributedString = NSAttributedString(string: PickerData[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let searchtextfield = resultSearchController.searchBar.valueForKey("searchField") as? UITextField
        searchtextfield?.text = PickerData[row]
        
    }
    
    func donePicker(){
        
        let searchtextfield = resultSearchController.searchBar.valueForKey("searchField") as? UITextField
        filterContentForSrechText((searchtextfield?.text)!)
        searchtextfield?.resignFirstResponder()

    }
    
    func cancelPicker(){
        let searchtextfield = resultSearchController.searchBar.valueForKey("searchField") as? UITextField
        searchtextfield?.resignFirstResponder()
       
    }
    // MARK: - Table view data sourc
    
    func refresh(){
        
        let query = PFQuery(className:"Events")
        var errorMsg = ""
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
    
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
  /*  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.resultSearchController.active){
            return nil
        }
        else{
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
            return headerview}
    }*/
    /*   override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     
     return self.details[section].start
     }*/
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       /* if (self.resultSearchController.active){
            return 1
        }
        else{
            return sortedsections.count}*/
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if (self.resultSearchController.active) {
            return self.filtereddetails.count
        }
        else {
            
          //  return self.eventlist[sortedsections[section]]!.count
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let data: TableData?
        data = filtereddetails[indexPath.row]
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
    
    @IBAction func BackButtonTapped(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellbackgroundview = UIView()
        cellbackgroundview.backgroundColor = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 73.0/255.0, alpha: 1)
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.selectedBackgroundView = cellbackgroundview
        self.resultSearchController.active = false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultsCell", forIndexPath: indexPath)

        let data : TableData
        if(self.resultSearchController.active){
            data = filtereddetails[indexPath.row]
        }
        else{
        data = details[indexPath.row]
        }
        
        cell.textLabel?.text = data.title
        cell.detailTextLabel?.text = "From: "+data.start+" To: "+data.stop

        return cell
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
       // let searchtextfield = searchController.searchBar.valueForKey("searchField") as? UITextField
       // filterContentForSrechText((searchtextfield?.text)!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "SearchResultsDetailView") {
            
            let viewController = segue.destinationViewController as! DetailTableViewController//UINavigationController
           // let detailview = viewController.topViewController as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let sentdata : TableData
                sentdata = filtereddetails[indexPath.row]
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
