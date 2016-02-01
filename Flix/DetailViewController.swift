//
//  DetailViewController.swift
//  Flix
//
//  Created by Noureddine Youssfi on 1/28/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var date: UILabel!
    var topicDate: String!
    var topicTitle: String!
    
    var movie: NSDictionary! 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        
        let title = movie["\(topicTitle)"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        
        let backUrl = "http://image.tmdb.org/t/p/w500"
        let baseUrl = "http://image.tmdb.org/t/p/w92/"
        
        if let posterPath = movie["backdrop_path"] as? String{
            let imageUrl =  NSURL(string: backUrl + posterPath)
            posterImageView.setImageWithURL(imageUrl!)
            //cell.textLabel!.text = title
            //        print(title)
        }
        if let imagePath = movie["poster_path"] as? String{
            let imageUrl =  NSURL(string: baseUrl + imagePath)
            posterView.setImageWithURL(imageUrl!)
            //cell.textLabel!.text = title
            //        print(title)
        }
        let dateReleased = movie["\(topicDate)"] as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let theDate = dateFormatter.dateFromString(dateReleased)
        dateFormatter.dateFormat = "MMM d"
        let dateText = dateFormatter.stringFromDate(theDate!)
        date.text = dateText
        
        print(movie)
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

}
