//
//  ContactViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 4/7/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ContactViewController: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        if Reachability.isConnectedToNetwork() == true {
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.navigationBar.tintColor = UIColor(red: 250/255.0, green: 171/255.0, blue: 0, alpha: 1)
        mailComposerVC.setToRecipients(["yashdeep.bali@sap.com"])
        mailComposerVC.setSubject("Issue Subject")
        mailComposerVC.setMessageBody("Please describe your issue", isHTML: false)
        }
        else {
            self.displayAlertMessage("No Internet Connection", errmessage: "Please check if the device is connected to the internet")
        }
        return mailComposerVC
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

  
    @IBAction func ClickHereButtonTapped(sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }else {
            
            self.displayAlertMessage("Could not send mail", errmessage: "Please try again later.")
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
