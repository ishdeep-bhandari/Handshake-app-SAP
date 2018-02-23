//
//  ForgotPassViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 3/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ForgotPassViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    let gradientLayer =  CAGradientLayer()
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let emailpadding = UIView()
        EmailTextField.leftView = emailpadding
        EmailTextField.leftViewMode = UITextFieldViewMode.Always
        emailpadding.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ResetButtonTapped(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true{
        if EmailTextField.text == ""{
        
            self.displayAlertMessage("Error Input", errmessage: "Please enter a valid email id")
        }
        else{
            
          PFUser.requestPasswordResetForEmailInBackground(EmailTextField.text!)
          self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
        else{
            self.displayAlertMessage("No Internet Connection", errmessage: "Please check if the device is connected to the internet")
        }
}
    
    @IBAction func CancelButtonTapped(sender: AnyObject) {
        
     self.dismissViewControllerAnimated(true, completion: nil)
    }
 
}
