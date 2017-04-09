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
    }

}
