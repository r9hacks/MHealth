//
//  AboutViewController.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/9/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var ourAim: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ourAim.text = NSLocalizedString("Our aim", comment: "")
        ourAim.textAlignment = .Center

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
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
