//
//  PageViewController.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 12/21/15.
//  Copyright © 2015 Colleen Rothe. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    var index = 0
    var identifiers: NSArray = ["FirstPage", "SecondPage", "ThirdPage", "FourthPage"] //matches storyboard identifiers
    let shareData = ShareData.sharedInstance //this stuff might be redundant...delete if not implemented
    
    
    override func viewDidLoad() {
        //self data source and delegate for page view controller
        self.dataSource = self
        self.delegate = self
        
        let startingViewController = self.viewControllerAtIndex(self.index)  //starting view controller is index at self
        let viewControllers: NSArray = [startingViewController] //array of starting view controllers
        self.setViewControllers((viewControllers as! [UIViewController]), direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil) //set view controllers
    }
    
    //which view controller is returned? based on the index
    func viewControllerAtIndex( index: Int) -> UIViewController! {
        if (index == 0){
            print("first")
            shareData.pageIndex = 0
            return (self.storyboard?.instantiateViewControllerWithIdentifier("FirstPage"))! as UIViewController
        }
        
        if (index == 1){
            print("second")
            shareData.pageIndex = 1
            return (self.storyboard?.instantiateViewControllerWithIdentifier("SecondPage"))! as UIViewController

        }
        
        if (index == 2){
            print("third")
            shareData.pageIndex = 2

            
            return (self.storyboard?.instantiateViewControllerWithIdentifier("ThirdPage"))! as UIViewController
            
        }
        
        if (index == 3){
            print("fourth")
            shareData.pageIndex = 3

            return (self.storyboard?.instantiateViewControllerWithIdentifier("FourthPage"))! as UIViewController
            
        }
        
        return nil
        
    }
    
    
    //moving forwards...
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        print("forward")

        let identifier = viewController.restorationIdentifier //get rid of?
        
        index = self.identifiers.indexOfObject(identifier!) //var index
        
        
        //if the index is end of array, return nil because there are no more view controllers
        if index == (identifiers.count - 1) {  
            
            return nil
        }
        
        //increment the index to get the next view controller after the current index
        index++  //self

        print(index);
        print(self.index);
        
        return self.viewControllerAtIndex(index) //self
        
        
        
    }
    
    
    //moving backwards...
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        print("backward")

        let identifier = viewController.restorationIdentifier //get rid of?
        index = self.identifiers.indexOfObject(identifier!) //var index

        
        //if the index is end of array, return nil because there are no more view controllers
        if index == 0 {
            
            return nil
        }
        
        //decrement the index to get the next view controller before the current one
        index-- //self
        
        print(index);
        print(self.index);

        return self.viewControllerAtIndex(index) //self
        
    }

    //get length of array
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
