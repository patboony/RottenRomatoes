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

    
    var photoURL: String = ""
    var currentMovie: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = currentMovie["title"] as? String

        // Do any additional setup after loading the view.
        var photoURL = currentMovie.valueForKeyPath("posters.original") as! String
        
        var range = photoURL.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        
        if let range = range {
            photoURL = photoURL.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        posterView.setImageWithURL(NSURL(string: photoURL))
        descriptionLabel.text = currentMovie["synopsis"] as? String
        
        descriptionView.contentSize = CGSizeMake(320, 700);

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
