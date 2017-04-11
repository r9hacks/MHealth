//
//  ProfileVC.swift
//  MHealth
//
//  Created by trn24 on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var specialtyLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var updateProfileButton: UIButton!

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: Const.UserDefaultsKeys.drProfile)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: Const.UserDefaultsKeys.doctorID)
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    @IBAction func btnEdit(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Upload Image", message: "Choose one of the two options", preferredStyle: .ActionSheet)

        let CameraRollAction = UIAlertAction(title: "Camera roll", style: .Default, handler: {(action: UIAlertAction) -> Void in
            print("Camera Roll")
            
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        })

        let CameraAction = UIAlertAction(title: "Take photo", style: .Default, handler: {(action: UIAlertAction) -> Void in
             print("Camera ")
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
             print("Cancel")
        })
        
        alertController.addAction(CameraAction)
        alertController.addAction(CameraRollAction)
        alertController.addAction(CancelAction)
        
        self.presentViewController(alertController, animated: true, completion: { _ in })

        print ("Button clicked")
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //Encode base64
        let imageData = UIImagePNGRepresentation(image)
        //var base64 = dataImage.base64EncodedStringWithOptions(NSDataBase64Encoding64CharacterLineLength)
        let strBase64:String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

        //Decode
       // let dataDecoded:NSData = NSData(base64EncodedString: strBase64, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!

        
        photo.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(ProfileVC.image(_:didFinishSavingWithError:contextInfo:)), nil)

        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        
//        if error == nil {
//            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        } else {
//            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        }
    }
    
    func loadImage(u:String) {
        if Validator().verifyUrl(u) == false{
            return
        }
        let url:NSURL = NSURL(string: u)!
        
        let data:NSData = NSData(contentsOfURL: url)!
        
        let doctorPhoto:UIImage? = UIImage(data: data)
        if doctorPhoto != nil {
            self.photo.image = doctorPhoto
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Customization().addUnderLineToLabel(nameLabel)
        Customization().addUnderLineToLabel(specialtyLabel)
        Customization().addUnderLineToLabel(locationLabel)
        Customization().addUnderLineToLabel(emailLabel)
        Customization().addUnderLineToLabel(phoneLabel)
        
        // Do any additional setup after loading the view.
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        
        nameLabel.text = currentDoctor.firstName + " " + currentDoctor.middleName + " " + currentDoctor.lastName
        specialtyLabel.text = currentDoctor.specialty
        locationLabel.text = currentDoctor.location
        emailLabel.text = currentDoctor.email
        phoneLabel.text = currentDoctor.phoneNumber
        
        //loadImage(currentDoctor.imageUrl)
        //self.performSelectorInBackground(Selector(loadImage(currentDoctor.imageUrl)), withObject: currentDoctor.imageUrl)
        //performSelector(#selector(loadImage), withObject: currentDoctor.imageUrl)
        
        
        let url:NSURL = NSURL(string: currentDoctor.imageUrl)!
        self.photo.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profileImage"))
            
        
        
        
        self.photo.layer.borderWidth = 2.0
        self.photo.layer.masksToBounds = true
        self.photo.layer.borderColor = Customization().UIColorFromRGB(0x4C9DB9).CGColor
        self.photo.layer.cornerRadius = self.photo.frame.size.height/2
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        
        nameLabel.text = currentDoctor.firstName + " " + currentDoctor.middleName + " " + currentDoctor.lastName
        specialtyLabel.text = currentDoctor.specialty
        locationLabel.text = currentDoctor.location
        emailLabel.text = currentDoctor.email
        phoneLabel.text = currentDoctor.phoneNumber

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
