//
//  SettingsTVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/9/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    @IBAction func shareButton(sender: UIBarButtonItem) {
        print("Share button pressed")
      //  let website = NSURL(string: "http://google.com/")!

        let objectsToShare = [NSLocalizedString("Let me recommend you this application: URL", comment: "")]
        
        let controller = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        // Exclude all activities except AirDrop.
        let excludedActivities = []
        controller.excludedActivityTypes = (excludedActivities as! [String])
        // Present the controller
        if (controller.popoverPresentationController != nil) {
           controller.popoverPresentationController!.sourceView = self.view
            controller.popoverPresentationController!.sourceRect = self.view.bounds
        }
        self.presentViewController(controller, animated: true, completion: { _ in })

    }

}
