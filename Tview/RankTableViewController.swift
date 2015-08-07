//
//  RankTableViewController.swift
//  Tview
//
//  Created by daclouds on 2015. 7. 13..
//
//

import UIKit

let BASE_URL = "http://apis.skplanetx.com/hoppin/tvseries"
let VERSION = 1
let PAGE = 1
let COUNT = 20
let GENRE_ID = ""
let ORDER = "rankasc"

var APP_KEY = ""

class RankTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var seriesList = [Series]()
    var filtered = [Series]()
    
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the search controller
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var hoppin: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("hoppin", ofType: "plist") {
            hoppin = NSDictionary(contentsOfFile: path)
        }
        if let dict = hoppin {
            // Use your dict here
            APP_KEY = dict["APP_KEY"] as! String
//            print(APP_KEY)
        }
        
        searchSeries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.searchController.searchBar.text != "" {
            return self.filtered.count
        } else {
            return seriesList.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SeriesTableViewCell = tableView.dequeueReusableCellWithIdentifier("SeriesTableViewCell", forIndexPath: indexPath) as! SeriesTableViewCell

        // Configure the cell...
//        cell.textLabel?.text = seriesList[indexPath.row].title
//        cell.detailTextLabel?.text = String(seriesList[indexPath.row].genreNames)
        
        var series: Series
        if self.searchController.searchBar.text != "" {
            series = filtered[indexPath.row]
        } else {
            series = seriesList[indexPath.row]
        }
        
        cell.title.text = series.title
        cell.genre.text = String(series.genreNames)
        cell.rating.text = String(stringInterpolationSegment: series.ratingAverage)
        cell.rank.text = String(indexPath.row + 1)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    func searchSeries() {
        
        let methodArguments = [
            "version": VERSION,
            "page": PAGE,
            "count": COUNT,
            "genreId": GENRE_ID,
            "order": ORDER
        ]
        search(methodArguments as! [String : AnyObject])
    }
    
    func httpGet(request: NSURLRequest!, callback: (NSDictionary, String?) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback(NSDictionary(), error!.localizedDescription)
            } else {
//                let result = NSString(data: data!, encoding:
//                    NSASCIIStringEncoding)!
                
                var parseError: NSError?
                let parseResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
                //                    print(parseResult)
                callback(parseResult as NSDictionary, nil)
            }
        }
        task.resume()
    }
    
    func search(methodArguments: [String : AnyObject]) {
        
        let urlString: String = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
//        print(url)
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("utf-8", forHTTPHeaderField: "Accept-Encoding")
        request.addValue(APP_KEY, forHTTPHeaderField: "appKey")
        request.HTTPMethod = "GET"
        
        httpGet(request) {
            (data, error) -> Void in
            if error != nil {
                print(error)
                return
            } else if (data["error"] != nil) {
                let error = data["error"] as! NSDictionary
                let message = error["message"] as! String
                var alert = UIAlertView(title: "Error", message: message, delegate: self, cancelButtonTitle: "Close")
                alert.show()
                return
            } else {
                let hoppin = data["hoppin"]! as! [String : AnyObject]
                let _seriesList = hoppin["seriesList"]! as! [String : AnyObject]
                let series = _seriesList["series"]! as! [AnyObject]
            
                for _series in series {
                    let seriesId = _series["seriesId"]! as! String
                    let title = _series["title"]! as! String
                    let genreIds = _series["genreIds"]! as! String
                    let genreNames = _series["genreNames"]! as! String
                    let ratingAverage: NSString = _series["ratingAverage"] as! String
                    let participant = _series["participant"] as! String
                    let linkUrl = _series["linkUrl"]! as! String
                    let s = Series(seriesId: seriesId, title: title, genreIds: genreIds, genreNames: genreNames, ratingAverage: ratingAverage.doubleValue, participant: participant.toInt()!, linkUrl: linkUrl)!
                    self.seriesList.append(s)
                }
            
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func escapedParameters(parameters: [String: AnyObject]) -> String {
        var urlVars = [String]()
        
        for (key, value) in parameters {
            let stringValue = "\(value)"
            
            let escapedValue: String! = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            urlVars += [key + "=" + "\(escapedValue)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + "&".join(urlVars)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var searchText = searchController.searchBar.text
        if (searchText != "") {
            self.filtered = self.seriesList.filter { (series: Series) -> Bool in
                let stringMatch = series.title.rangeOfString(searchText)
                return (stringMatch != nil)
            }
        }
        self.tableView.reloadData()
    }

}
