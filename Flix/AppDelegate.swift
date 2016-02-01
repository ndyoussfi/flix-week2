//
//  AppDelegate.swift
//  Flix
//
//  Created by Noureddine Youssfi on 1/28/16.
//  Copyright © 2016 Noureddine Youssfi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let nowPlayingNavigationController = storyBoard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
//        nowPlayingNavigationController.movieMenu()
        nowPlayingViewController.endPoint = "now_playing"
        nowPlayingViewController.topicUrl = nowPlayingViewController.movieBaseUrl
        nowPlayingViewController.topicTitle = "title"
        nowPlayingViewController.topicDate = "release_date"
        nowPlayingViewController.movieSelections[0] = "Now playing"
        nowPlayingViewController.movieSelections[1] = "Top rated"
        nowPlayingViewController.movieSelections[2] = "Popular"
        nowPlayingViewController.movieSelections[3] = "Upcoming"
        nowPlayingViewController.movieEndPoints[0] = "now_playing"
        nowPlayingViewController.movieEndPoints[1] = "top_rated"
        nowPlayingViewController.movieEndPoints[2] = "popular"
        nowPlayingViewController.movieEndPoints[3] = "upcoming"
//        nowPlayingViewController.tableView.hidden = false
//        nowPlayingViewController.collectionView.hidden = true
        
        
        nowPlayingNavigationController.tabBarItem.title = "Movies"
        
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "movies")
        
        let topRatedNavigationController = storyBoard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
//        topRatedViewController.tvMenu()
        topRatedViewController.endPoint = "on_the_air"
        topRatedViewController.topicUrl = topRatedViewController.tvBaseUrl
        topRatedViewController.topicTitle = "name"
        topRatedViewController.topicDate = "first_air_date"
        topRatedViewController.movieSelections[0] = "On the Air"
        topRatedViewController.movieSelections[1] = "Top rated"
        topRatedViewController.movieSelections[2] = "Airing Today"
        topRatedViewController.movieSelections[3] = "Popular"
        topRatedViewController.movieEndPoints[0] = "on_the_air"
        topRatedViewController.movieEndPoints[1] = "top_rated"
        topRatedViewController.movieEndPoints[2] = "popular"
        topRatedViewController.movieEndPoints[3] = "airing_today"
//        topRatedViewController.tableView.hidden = true
//        topRatedViewController.collectionView.hidden = false
        
        topRatedNavigationController.tabBarItem.title = "Tv Shows"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "shows")
        
       
        
        

        
//        let popularNavigationController = storyBoard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
//        let popularViewController = popularNavigationController.topViewController as! MoviesViewController
//        popularViewController.endPoint = "popular"
//        popularNavigationController.tabBarItem.title = "Popular"
//        popularNavigationController.tabBarItem.image = UIImage(named: "")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController] //,popularNavigationController]
        tabBarController.tabBar.tintColor = UIColor.whiteColor()
        tabBarController.tabBar.barTintColor = UIColor.blackColor()
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

