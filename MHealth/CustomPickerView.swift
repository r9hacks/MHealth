//
//  CustomPickerView.swift
//  
//
//  Created by Ahmad alkandari on 4/10/17.
//
//

import UIKit

class CustomPickerView: UIView {

    @IBOutlet var view: UIView!
    
    var parentReportTVC:ReportsTVC?
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        parentReportTVC?.filterBarButtonAction(UIBarButtonItem())
        //self.view.removeFromSuperview()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NSBundle.mainBundle().loadNibNamed("CustomPickerView", owner: self, options: nil)
        
        self.bounds = self.view.bounds
        
        pickerView.selectRow(1, inComponent: 0, animated: true)
        
        
        self.addSubview(self.view)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
