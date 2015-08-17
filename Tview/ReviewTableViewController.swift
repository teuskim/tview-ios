//
//  ReviewTableViewController.swift
//  Tview
//
//  Created by daclouds on 2015. 8. 11..
//
//

import UIKit

import Parse

class ReviewTableViewController: UITableViewController {

    var reviews = [Review]()
    var review = Review?()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        navigationItem.leftBarButtonItem = editButtonItem()
        
        let query = PFQuery(className: "Review")
//        query.limit = 20

        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let r = Review(objectId: object["objectId"] as! String, comment: object["comment"] as! String, author: object["author"] as! String)!
                        self.reviews.append(r)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return reviews.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = reviews[indexPath.row].comment
        cell.detailTextLabel?.text = reviews[indexPath.row].author
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var _review = self.reviews[indexPath.row]
            
            // Delete the row from the data source
            reviews.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            var query = PFQuery(className: "Review")
            query.getObjectInBackgroundWithId(_review.objectId) {
                (review: PFObject?, error: NSError?) -> Void in
                if error == nil && review != nil {
                    print(review)
                    review!.deleteInBackground()
                } else {
                    print(error)
                }
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let reviewViewController = segue.destinationViewController as! ReviewViewController
            if let selectedReviewCell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(selectedReviewCell)!
                let selectedReview = reviews[indexPath.row]
                reviewViewController.review = selectedReview
            }
        } else if segue.identifier == "AddItem" {
            println("Adding new review")
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? ReviewViewController, review = sourceViewController.review {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow() {
                // Update an existing review.
                reviews[selectedIndexPath.row] = review
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new review.
                let newIndexPath = NSIndexPath(forRow: reviews.count, inSection: 0)
                reviews.append(review)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }

}
