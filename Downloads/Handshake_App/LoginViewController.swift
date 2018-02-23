//
//  LoginViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 2/24/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import SystemConfiguration

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var ScrollView: UIScrollView!

    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let scrollpoint: CGPoint = CGPointMake(0, textField.frame.origin.y)
        ScrollView.setContentOffset(scrollpoint, animated: true)
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        ScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFUser.logOut()
        
        Username.delegate = self
        Password.delegate = self

        let userpadding = UIView()
        Username.leftView = userpadding
        Username.leftViewMode = UITextFieldViewMode.Always
        userpadding.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        
        let passpadding = UIView()
        Password.leftView = passpadding
        Password.leftViewMode = UITextFieldViewMode.Always
        passpadding.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
       
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(LoginViewController.dismisskeyboard) )
        self.view.addGestureRecognizer(tap)
    }
    
    func dismisskeyboard(){
        Username.resignFirstResponder()
        Password.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginButtonTapped(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
        let usrname = Username.text
        let pass = Password.text
        var errorMsg = " "
        if(usrname == "" || pass == "" ){
            
         self.displayAlertMessage("Login Failed", errmessage: "Invalid Details Entered")
        }
        else{
            PFUser.logInWithUsernameInBackground(usrname!, password:pass!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil{
                    let installation = PFInstallation.currentInstallation()
                    installation["user"] = PFUser.currentUser()
                    installation.addUniqueObject("Reload", forKey: "channels")
                    installation.saveInBackground()
                    self.performSegueWithIdentifier("Loggedin", sender: self)
                    
                } else {
                    if  let errorString = error!.userInfo["error"] as? String{
                        
                        errorMsg = errorString
                    }
                    self.displayAlertMessage("Login Failed", errmessage: errorMsg)
                 }
            }
            }
        }
        else{
           self.displayAlertMessage("No Internet Connection", errmessage: "Please check if the device is connected to the internet") 
        }
    }
    
    @IBAction func ForgotButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("ForgotView", sender: self)
    }

}
