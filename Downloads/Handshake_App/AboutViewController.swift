//
//  AboutViewController.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 4/7/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(AboutViewController.goback) )
        self.view.addGestureRecognizer(tap)
    }

    func goback(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
