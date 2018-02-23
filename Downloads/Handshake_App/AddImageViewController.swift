//
//  AddImageViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 3/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

/*import UIKit
import Parse


class AddImageViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    var imagetitle:String = " "
    
    func displayAlertMessage(title: String, errmessage: String)
    {
        let MyAlert = UIAlertController(title: title, message: errmessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        MyAlert.addAction(okAction)
        
        self.presentViewController(MyAlert, animated: true, completion: nil)
        
    }
    
    var activityindicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
 
    @IBOutlet weak var ImageToPost: UIImageView!

  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        ImageToPost.hidden = false
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        ImageToPost.image = image
        
    }

    let gradientLayer =  CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        
        ImageToPost.hidden = true
        
        gradientLayer.frame = self.view.bounds
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
        let color1 = UIColor(red: (69/255.0), green: (69/255.0), blue:(69/255.0), alpha: 0.05).CGColor as CGColorRef
        let color2 = UIColor(red: (71/255.0), green: (71/255.0), blue:(71/255.0), alpha: 0.05).CGColor as CGColorRef
        let color3 = UIColor(red: (200/255.0), green: (200/255.0), blue:(200/255.0), alpha: 0.05).CGColor as CGColorRef
        let color4 = UIColor.whiteColor().CGColor as CGColorRef
        gradientLayer.colors = [color1,color2,color3,color4]
        
        gradientLayer.locations = [0.0,0.25,0.75,1.0]
        
        self.view.layer.addSublayer(gradientLayer)
        
        if #available(iOS 9.0, *) {
            (UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UIImagePickerController.self])).tintColor = UIColor.whiteColor()
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func PostImageButtonTapped(sender: AnyObject) {
        
        self.activityindicator = UIActivityIndicatorView(frame: self.view.frame)
        activityindicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        self.activityindicator.center = self.view.center
        self.activityindicator.hidesWhenStopped = true
        self.activityindicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.activityindicator)
        self.activityindicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "EventImages")
        
        let imagedata = UIImageJPEGRepresentation(ImageToPost.image!,0.7)
        
        let imagefile = PFFile(name: "image.jpeg", data: imagedata!)
        
        post["imagefile"] = imagefile
        post["event"] = self.imagetitle
        
        post.saveInBackgroundWithBlock{(success, error) -> Void in
            
            self.activityindicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil{
                self.displayAlertMessage("Image added", errmessage: "Your image has been added!")
            }
            else{
                self.displayAlertMessage("Image not added", errmessage: "Please try again later!")
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}*/
