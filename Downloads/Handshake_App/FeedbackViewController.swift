//
//  FeedbackViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 4/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedbackViewController: UIViewController,FloatRatingViewDelegate{
    
    @IBOutlet weak var Rating: FloatRatingView!
    var SelectedText: String = " "
    var UpdatedText: String = " "
    var delegate : SavingViewControllerDelegate?
    var titleevent: String = " "
    var eventfeedback : String = " "
    var eventobjectid : String = " "
    var eventfeedbackcounter : String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if((self.delegate) != nil)
        {
            delegate?.saveText(titleevent)
        }
        print("Title: " + titleevent)

        let query = PFQuery(className: "Events")
        query.whereKey("Name", equalTo: titleevent)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            
            if error != nil || object == nil {
                self.displayAlertMessage("Error Retrieving Information", errmessage: "There was an error retrieving data. Please try again")
            } else {
                
                self.eventfeedback = object?.valueForKey("Feedback") as! String
                self.eventobjectid = object?.valueForKey("objectId") as! String
                self.eventfeedbackcounter = object?.valueForKey("Feedbackcounter") as! String
            }
        }

        Rating.delegate = self
        Rating.emptyImage = UIImage(named: "StarEmpty.png")
        Rating.fullImage = UIImage(named: "StarFull.png")
        Rating.contentMode = UIViewContentMode.ScaleAspectFit
        Rating.halfRatings = true
        Rating.maxRating = 5
        Rating.minRating = 1
        Rating.editable = true
        SelectedText = NSString(format: "%.2f", Rating.rating) as String
        UpdatedText = NSString(format: "%.2f", Rating.rating) as String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        SelectedText = NSString(format: "%.2f", Rating.rating) as String
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
       UpdatedText = NSString(format: "%.2f", Rating.rating) as String
    }

    @IBAction func CancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    @IBAction func RateButtonTapped(sender: AnyObject) {
       let selectednumber = (SelectedText as NSString).floatValue
       var feedbacknumber = (self.eventfeedback as NSString).floatValue
       var feedbackcounter = (self.eventfeedbackcounter as NSString).floatValue
        if feedbackcounter == 0.0{
         feedbacknumber = selectednumber + feedbacknumber
         feedbackcounter += 1
        }
        else{
       feedbackcounter += 1
            feedbacknumber = (selectednumber + feedbacknumber)/2}
       self.eventfeedback = NSString(format: "%.2f", feedbacknumber) as String
       self.eventfeedbackcounter = NSString(format: "%.2f", feedbackcounter) as String
        let query = PFQuery(className:"Events")
        
        query.getObjectInBackgroundWithId(eventobjectid) {
            (event: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let event = event{
                event["Feedback"] = self.eventfeedback
                event["Feedbackcounter"] = self.eventfeedbackcounter
                event.saveInBackgroundWithBlock{(success, error) -> Void in
                    if (success == true){
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else
                    {
                        self.displayAlertMessage("Error during Rating", errmessage: "Please try again")
                    }
                }
            }
        }
        
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
