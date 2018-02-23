//
//  ViewImageViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 3/6/16.
//  Copyright © 2016 Parse. All rights reserved.
//

/*import UIKit
import Parse

class ViewImageViewController: UIViewController,UIScrollViewDelegate {
    
    let gradientLayer =  CAGradientLayer()
    
    var imagetitle:String = " "
    
    var activityindicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var ImageScrollView: UIScrollView!
    
    var ImageToView: UIImageView!
    var images = [PFFile]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        
        self.activityindicator = UIActivityIndicatorView(frame: self.view.frame)
        activityindicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        self.activityindicator.center = self.view.center
        self.activityindicator.hidesWhenStopped = true
        self.activityindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.activityindicator)
        self.activityindicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let query = PFQuery(className: "EventImages")
        query.whereKey("event", equalTo: imagetitle)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            self.activityindicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil  {
                if let objects = objects{
                    for object in objects{
                        self.images.append(object.valueForKey("imagefile") as! PFFile)
                    }
                }
               
            } else {
                    self.displayAlertMessage("Error Retrieving Information", errmessage: "There was an error retrieving data. Please try again")
            }
        }
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(red: (69/255.0), green: (69/255.0), blue:(69/255.0), alpha: 0.05).CGColor as CGColorRef
        let color2 = UIColor(red: (71/255.0), green: (71/255.0), blue:(71/255.0), alpha: 0.05).CGColor as CGColorRef
        let color3 = UIColor(red: (200/255.0), green: (200/255.0), blue:(200/255.0), alpha: 0.05).CGColor as CGColorRef
        let color4 = UIColor.whiteColor().CGColor as CGColorRef
        gradientLayer.colors = [color1,color2,color3,color4]
        
        gradientLayer.locations = [0.0,0.25,0.75,1.0]
        
        self.view.layer.addSublayer(gradientLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancellButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayAlertMessage(title: String, errmessage: String)
    {
        let MyAlert = UIAlertController(title: title, message: errmessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        MyAlert.addAction(okAction)
        
        MyAlert.view.tintColor = UIColor(red: (22/255.0), green: (41/255.0), blue:(141/255.0), alpha: 1)
        
        self.presentViewController(MyAlert, animated: true, completion: nil)
        
        MyAlert.view.tintColor = UIColor(red: (22/255.0), green: (41/255.0), blue:(141/255.0), alpha: 1)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}*/
