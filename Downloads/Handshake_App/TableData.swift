//
//  Data.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 3/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

extension UIViewController
{
    
 func displayAlertMessage(title: String, errmessage: String)
{
    let MyAlert = UIAlertController(title: title, message: errmessage, preferredStyle: UIAlertControllerStyle.Alert)
    
    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
    
    MyAlert.addAction(okAction)
    
    MyAlert.view.tintColor = UIColor(red: (22/255.0), green: (41/255.0), blue:(141/255.0), alpha: 1)
    
    self.presentViewController(MyAlert, animated: true, completion: nil)
    
    MyAlert.view.tintColor = UIColor(red: (22/255.0), green: (41/255.0), blue:(141/255.0), alpha: 1)
}
    
    
func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

struct TableData{
    let title : String
    let start : String
    let stop : String
    let segment : String
    let audience : String
    let location: String
    let organiser: String
    let description: String
    let feedback: String
    let feedbackcounter: String
    let mgo: String
    let mip: String
    var userid: String
    var attendees: String
    var crmcode: String
    var objectid: String
}