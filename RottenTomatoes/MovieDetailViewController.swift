//
//  MovieDetailViewController.swift
//  RottenTomatoes
//
//  Created by Pat Boonyarittipong on 4/12/15.
//  Copyright (c) 2015 patboony. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var descriptionView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionBackground: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var photoURL: String = ""
    var currentMovie: NSDictionary = NSDictionary()
    
    func convertToHiResURL(photoURL: String) -> String {
        var range = photoURL.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        var hiResURL: String = photoURL
        
        if let range = range {
            hiResURL = photoURL.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        return hiResURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = currentMovie["title"] as? String
        descriptionView.bounces = false
        
        // Load low-res images first
        posterView.setImageWithURL(NSURL(string: currentMovie.valueForKeyPath("posters.original") as! String))
        
        // Load high-res afterward
        var photoURL = convertToHiResURL(currentMovie.valueForKeyPath("posters.original") as! String)
        posterView.setImageWithURL(NSURL(string: photoURL))
        
        titleLabel.text = currentMovie["title"] as? String
        var critics_score = currentMovie.valueForKeyPath("ratings.critics_score") as! Int
        var audience_score = currentMovie.valueForKeyPath("ratings.audience_score") as! Int
        scoreLabel.text = "Critics Score: " + String(critics_score) + ", Audience Score: " + String(audience_score)
        
        descriptionLabel.text = currentMovie["synopsis"] as! String + "\r\n\r\n"
        descriptionLabel.sizeToFit()
        
        NSLog(String(stringInterpolationSegment: descriptionLabel.frame.height))
        let contentWidth = descriptionView.bounds.width
        let contentHeight = descriptionLabel.frame.height + 420
        descriptionView.contentSize = CGSizeMake(contentWidth, contentHeight)

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
