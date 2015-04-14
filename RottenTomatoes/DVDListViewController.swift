//
//  DVDListViewController.swift
//  RottenTomatoes
//
//  Created by Pat Boonyarittipong on 4/13/15.
//  Copyright (c) 2015 patboony. All rights reserved.
//

import UIKit

class DVDListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // Array of NSDictionary storing information about movies obtained from RottenTomatues Feed
    var movies = []
    
    // Storing the UILabel object representing the notification bar, which is shown when connection fails
    var notificationBar: UILabel?
    //For refreshControl
    var refreshControl: UIRefreshControl!
    
    // Show notification bar at the top - used when connection to the server fails
    func showTopBar(errorMessage: String) {
        
        if notificationBar != nil {
            notificationBar!.text = errorMessage
        } else {
            let notificationLabel = UILabel(frame: CGRectMake(0, 0, 323, 30))
            notificationLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            notificationLabel.textColor = UIColor.whiteColor()
            notificationLabel.textAlignment = NSTextAlignment.Center
            notificationLabel.font = UIFont(name: "Helvetica-Bold", size: 12)
            notificationLabel.text = errorMessage
            
            NSLog("setting hidden to false")
            //notificationView.hidden = false
            notificationBar = notificationLabel
            self.tableView.addSubview(notificationBar!)
        }
        
    }
    
    // Remove the notification bar at the tob
    func removeTopBar() {
        notificationBar?.removeFromSuperview()
        notificationBar = nil
    }
    
    // Used JGProgressHUD to create the loading notification
    func showHUD(message: String) -> JGProgressHUD {
        var HUD: JGProgressHUD = JGProgressHUD(style: JGProgressHUDStyle.Dark)
        HUD.textLabel.text = message;
        HUD.showInView(self.view)
        return HUD
    }
    
    // Establish the connection to the server and parse JSON into movies (which is [NSDictionary])
    func connectToAPI() {
        let apikey = "3r58wrkvgxtzpebbdnm3chvx"
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=\(apikey)")
        var request = NSURLRequest(URL: url!)
        
        // Test loading
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // API loading
            var apiLoadingHUD = self.showHUD("Loading")
            
            if error != nil {
                NSLog("connection failed")
                apiLoadingHUD.dismissAnimated(true)
                self.showTopBar("Connection to RottenTomatoes Failed")
                
            } else {
                NSLog("connection successful")
                apiLoadingHUD.dismissAnimated(true)
                var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                self.movies = json["movies"] as! NSArray
                self.tableView.reloadData()
                self.removeTopBar()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        connectToAPI()
        
        // Add refreshControl
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // load the table
        tableView.rowHeight = 100
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("numberOfRowsInSection " + String(movies.count))
        return movies.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Movie Cell", forIndexPath: indexPath) as! MovieViewCell
        var currentMovie = movies[indexPath.row] as! NSDictionary
        //println("showing row " + String(indexPath.row))
        
        // What if force downcast fails?
        var photoURL = currentMovie.valueForKeyPath("posters.original") as! String
        
        cell.movieImageView.setImageWithURL(NSURL(string: photoURL))
        // Why use ?
        cell.movieTitleLabel.text = currentMovie["title"] as? String
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        var mpaa_rating = currentMovie["mpaa_rating"] as! String
        var synopsis = currentMovie["synopsis"] as! String
        
        cell.movieDescriptionLabel.text = mpaa_rating + " " + synopsis
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movieDetailVC = segue.destinationViewController as! MovieDetailViewController
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell) as NSIndexPath!
        movieDetailVC.currentMovie = movies[indexPath.row] as! NSDictionary
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        connectToAPI()
        // how do we actaully make sure that the connection is successful?
        delay(1, closure: {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }

}
