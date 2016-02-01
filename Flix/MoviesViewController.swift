//
//  MoviesViewController.swift
//  Flix
//
//  Created by Noureddine Youssfi on 1/28/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//

import UIKit
import AFNetworking
import PKHUD
import BTNavigationDropdownMenu

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   
    
    var movies: [NSDictionary]?
    var searchedMovies: [NSDictionary]?
    var endPoint: String!
    var refresh = UIRefreshControl()
    var movieSelections = ["Now playing", "Top rated", "Popular", "Upcoming"]
    let tvSelections = ["On the Air", "Top Rated", "Airing Today", "Popular"]
    var movieEndPoints = ["now_playing", "top_rated", "popular", "upcoming"]
    let tvEndPoints = ["on_the_air","top_rated","popular","airing_today"]
    let tvBaseUrl = "http://api.themoviedb.org/3/tv/"
    let movieBaseUrl = "https://api.themoviedb.org/3/movie/"
    var topicUrl: String!
    var topicTitle: String!
    var topicDate: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.hidden = true
//        collectionView.hidden = true
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        movieMenu()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        
        
        refreshControl()
        networkRequest()
        

        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let searchedMovies = searchedMovies {
            return searchedMovies.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as!MovieCell
        let movie = searchedMovies![indexPath.row]
        
        let title = movie[topicTitle] as! String
        cell.titleLabel.textColor = UIColor.whiteColor()
        cell.titleLabel.text = title
        
        let popularity = movie["popularity"] as! NSNumber
        var color = UIColor(red: 0.27, green: 0.62, blue: 0.27, alpha: 1);
        if(popularity.integerValue < 40) {
            color = UIColor(red: 0.223, green: 0.52, blue: 0.223, alpha: 1);
        }
        if(popularity.integerValue < 20) {
            color = UIColor(red: 0.95, green: 0.6, blue: 0.071, alpha: 1);
        }
        if(popularity.integerValue < 10) {
            color = UIColor(red: 0.90, green: 0.5, blue: 0.13, alpha: 1);
        }
        if(popularity.integerValue < 6) {
            color = UIColor(red: 0.83, green: 0.33, blue: 0.33, alpha: 1);
        }
        if(popularity.integerValue < 5) {
            color = UIColor(red: 0.91, green: 0.3, blue: 0.235, alpha: 1);
        }
        if(popularity.integerValue < 4) {
            color = UIColor(red: 0.75, green: 0.22, blue: 0.22, alpha: 1);
        }
        cell.coloredView.layer.backgroundColor = color.CGColor;
        
        let dateReleased = movie["\(topicDate)"] as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(dateReleased)
        dateFormatter.dateFormat = "MMM d"
        let dateText = dateFormatter.stringFromDate(date!)
        cell.date.text = dateText
        //        cell.date.text = dateReleased
        
        let vote = movie["vote_average"] as! NSNumber
        cell.popularity.text = vote.stringValue
        
        let overview = movie["overview"] as! String
        cell.overviewLabel.text = overview
        cell.overviewLabel.textColor = UIColor.whiteColor()
        
        let baseUrl = "http://image.tmdb.org/t/p/w185"
        if let posterPath = movie["poster_path"] as? String{
            let imageUrl =  NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        //cell.textLabel!.text = title
//        print(title)
//            tableView.reloadData()
        }
        return cell
            
    }
    func networkRequest(){
        let apiKey = "05c69b790262f896811556cdcb0ceb3b"
        let url = NSURL(string: "\(topicUrl)\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )

        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
//                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.searchedMovies = self.movies
                            self.tableView.reloadData()
                            self.progress()
                    }
                }
        });
        task.resume()
    }
    func progress(){
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
            PKHUD.sharedHUD.hide(afterDelay: 1.5)
        }
    }
    func refreshControl(){
        self.refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshControlAction", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refresh)
        self.refresh.backgroundColor = UIColor.darkGrayColor()
        self.refresh.tintColor = UIColor.whiteColor()
//        self.networkRequest()
//        self.tableView.reloadData()
//        self.progress()
        
//        var targetView: UIView {
//            return self.view
//        }

    }
    func refreshControlAction(){
        
        self.networkRequest()
        self.tableView.reloadData()
//        self.progress()
        self.refresh.endRefreshing()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = searchedMovies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        detailViewController.topicDate = topicDate
        detailViewController.topicTitle = topicTitle
        
//        print("prepare for segue")
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            
            searchedMovies = movies
        } else {
            searchedMovies = movies?.filter({ (movie: NSDictionary) -> Bool in
                if let title = movie[topicTitle] as? String {
                    if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                        
                        return  true
                    } else {
                        return false
                    }
                }
                return false
            })
        }
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
     }
//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        
//        self.searchBar.setShowsCancelButton(false, animated: true)
//        
//    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        (searchedMovies, searchBar.text) = (movies, "")
        self.searchBar.setShowsCancelButton(false, animated: true)
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func movieMenu(){
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: movieSelections.first!, items: movieSelections)
        self.navigationItem.titleView = menuView
        menuView.cellBackgroundColor = UIColor.darkGrayColor()
//        menuView.cellTextLabelFont = UIFont.s
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            self.endPoint = self.movieEndPoints[indexPath]
            //                print(self.movieEndPoints[indexPath])
            self.networkRequest()
            self.tableView.reloadData()
            self.progress()
            
            //            self.selectedCellLabel.text = items[indexPath]
        }
    }
    
//    func tvMenu(){
//        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: tvSelections.first!, items: tvSelections)
//        self.navigationItem.titleView = menuView
//        menuView.cellBackgroundColor = UIColor.darkGrayColor()
//        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
//            print("Did select item at index: \(indexPath)")
//            self.endPoint = self.tvEndPoints[indexPath]
//            //                print(self.movieEndPoints[indexPath])
//            self.networkRequest()
//            self.tableView.reloadData()
//            self.progress()
//            
//            //            self.selectedCellLabel.text = items[indexPath]
//        }
//    }
    
}
