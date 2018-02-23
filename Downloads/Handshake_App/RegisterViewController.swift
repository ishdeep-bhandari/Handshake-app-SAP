//
//  RegisterViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 2/24/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    var activityindicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var UserEmailTextField: UITextField!
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var UserPassTextField: UITextField!
    @IBOutlet weak var RepeatPassTextField: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
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
        
        UserNameTextField.delegate = self
        UserEmailTextField.delegate = self
        UserPassTextField.delegate = self
        RepeatPassTextField.delegate = self
        
        let userpadding = UIView()
        UserNameTextField.leftView = userpadding
        UserNameTextField.leftViewMode = UITextFieldViewMode.Always
        userpadding.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        
        let passpadding = UIView()
        UserPassTextField.leftView = passpadding
        UserPassTextField.leftViewMode = UITextFieldViewMode.Always
        passpadding.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        
        let emailpadding = UIView()
        UserEmailTextField.leftView = emailpadding
        UserEmailTextField.leftViewMode = UITextFieldViewMode.Always
        emailpadding.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        
        let reppasspadding = UIView()
        RepeatPassTextField.leftView = reppasspadding
        RepeatPassTextField.leftViewMode = UITextFieldViewMode.Always
        reppasspadding.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(RegisterViewController.dismisskeyboard) )
        self.view.addGestureRecognizer(tap)
  
    }
    
    func dismisskeyboard(){
        UserEmailTextField.resignFirstResponder()
        UserPassTextField.resignFirstResponder()
        UserNameTextField.resignFirstResponder()
        RepeatPassTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RegisterButtonTap(sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true{
        
        let useremail = UserEmailTextField.text
        let usrname = UserNameTextField.text
        let userpass = UserPassTextField.text
        let reppass = RepeatPassTextField.text
        
        if (useremail?.characters.count == 0 || usrname?.characters.count == 0 || userpass?.characters.count == 0 || reppass?.characters.count == 0)
        {
            self.displayAlertMessage("Empty Fields",errmessage: "Please Fill all the Fields")
        }
        else{
            
            if(isValidEmail(useremail!)) == false {
                
                self.displayAlertMessage("Invalid Email",errmessage: "Please enter a valid email address");
                
            }
                
            else {
                if Passwordcomplexity(userpass!) == false && userpass?.characters.count < 8  {
                    self.displayAlertMessage("Re-enter Password", errmessage: "The password should be at least 8 characters long with 1 captial and 1 special character")
                }
                    
                else {
                    
                    if (userpass == reppass)
                    {
                        self.activityindicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
                        self.activityindicator.center = self.view.center
                        self.activityindicator.hidesWhenStopped = true
                        self.activityindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                        view.addSubview(self.activityindicator)
                        self.activityindicator.startAnimating()
                        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                        
                        let user = PFUser()
                        user.username = usrname
                        user.password = userpass
                        user.email = useremail
                        
                        var errorMsg = "There was problem signing up"
                        
                        user.signUpInBackgroundWithBlock ({
                            (success , error) -> Void in
                            
                            self.activityindicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            if error == nil {
                                let installation = PFInstallation.currentInstallation()
                                installation["user"] = PFUser.currentUser()
                                installation.addUniqueObject("Reload", forKey: "channels")
                                installation.saveInBackground()
                                let newuser = PFUser.currentUser()
                                newuser!["UserType"] = "Viewer"
                                newuser!.saveInBackgroundWithBlock{(success, error) -> Void in
                                    if (success == true){
                                        
                                    }else{}
                                }
                                self.dismissViewControllerAnimated(true, completion: nil)
                                
                            } else
                            {
                                if  let errorString = error!.userInfo["error"] as? String{
                                    
                                    errorMsg = errorString
                                }
                                self.displayAlertMessage("Failed Sign up", errmessage: errorMsg)
                            }
                        })
                    }
                
                else{
                        self.displayAlertMessage("Alert",errmessage: "Passwords must match");
                    }
                    
                }
            }
            
        }
            
    }
        else{
           self.displayAlertMessage("No Internet Connection", errmessage: "Please check if the device is connected to the internet") 
        }
}
 
    @IBAction func Alreadyauserbuttontapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+[.]+[A-Z0-9a-z._%+-]+@sap+\\.com"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    func Passwordcomplexity(text : String) -> Bool{
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluateWithObject(text)
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluateWithObject(text)
        
        return capitalresult && specialresult
        
    }

}