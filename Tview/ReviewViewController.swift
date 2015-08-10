//
//  ReviewViewController.swift
//  Tview
//
//  Created by daclouds on 2015. 8. 10..
//
//

import UIKit

import Parse

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var comment: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func save(sender: UIBarButtonItem) {
        let reviewObject = PFObject(className: "Review")
        reviewObject["comment"] = comment.text
        reviewObject.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            var alert: UIAlertView
            if (success) {
                let message = "Object has been saved."
                alert = UIAlertView(title: "Success", message: message, delegate: self, cancelButtonTitle: "Close")
            } else {
                alert = UIAlertView(title: "Error", message: error?.description, delegate: self, cancelButtonTitle: "Close")
            }
            alert.show()
        })
    }

}
