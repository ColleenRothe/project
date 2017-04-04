//
//  SiteImages.swift
//  USMPTest1
//
//  Corresponds to ViewController that holds sliding view of all the images
//  that go with a site, when you click on the button from it's AnnotationInfo page
//
//  Created by Colleen Rothe on 3/4/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//CREDITS:
//https://stackoverflow.com/questions/30440660/start-uiscrollview-with-an-image-of-particular-index-from-another-view
//https://www.raywenderlich.com/122139/uiscrollview-tutorial

import Foundation
import UIKit
import CoreData


class SiteImages: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scroller: UIScrollView!
    
    var pageImages: [UIImage] = [] //hold all images to display
    var pageViews: [UIImageView?] = [] //hold instances of UIImageView to display each image
    
    let shareData = ShareData.sharedInstance
    var tapped = UITapGestureRecognizer()  //each tap gesture recobnizer can only be connected to one view!!!
    
    var tapNum = 0;
    var frame = CGRect()

    //offline func.
    var site = [NSManagedObject]()             //core data sites
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.delegate = self
        scroller.isUserInteractionEnabled = true
        scroller.minimumZoomScale = 1
        scroller.maximumZoomScale = 6
        
        //add an action if you tap on a picture
        tapped = UITapGestureRecognizer(target: self, action: #selector(SiteImages.tapPic))
        
        //working offline
        if(shareData.offline == true){
            loadOfflineImages()
        }
        //working online
        if(shareData.offline == false){
            loadImages()
        }
    }
    
    //you tap on a picture
    func tapPic(_ sender: UIImageView!){
        //allow user interaction
        view.isUserInteractionEnabled = true
        
        //make the picture bigger
        if(tapNum == 0){
        frame = view.frame
        view.transform = CGAffineTransform(scaleX: 2, y: 2)
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            tapNum = 1
        }
        //put the image back to its normal size
        else if (tapNum == 1){
            view.transform = CGAffineTransform.identity
            view.frame = frame
            tapNum = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //load images
    func loadImages(){
        let photo_string = shareData.photo_string
        var pics: [String] = []
        
        let fullArray = photo_string.components(separatedBy: ",")
        
        for j in 0 ..< fullArray.count{
            let mid = fullArray[j]
            pics.append(mid )
            }
        
        pageImages = []
        
        //crashes if no pictures...
        if(pics[0] != ""){
            //get the image from the server
        for i in 0 ..< pics.count{
            let path = pics[i]
            let urlPath: String = "http://nl.cs.montana.edu/usmp_media/photo_thumbnails/\(path)"
            let url: URL = URL(string: urlPath)!
            let data = try? Data(contentsOf: url)
            let image = UIImage(data: data!)
            pageImages.append(image!)
        }
        }
        
        let pageCount = pageImages.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount{
            pageViews.append(nil)
        }
        
        let pagesScrollViewSize = scroller.frame.size
        scroller.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        loadVisiblePages()
    }
    
    //load images when in offline mode
    func loadOfflineImages(){
        //for some reason, all of the images are shown twice?...
        
        pageImages = []
        
        //core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineSite")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            site = results as! [NSManagedObject]

            for pz in 0 ..< site.count{
            
                
                //check if they match..when you click on a point saves the title to share/current id
                if site[pz].value(forKey: "siteID") as? String == shareData.current_site_id{
                    
                    //pull each image (saved as data1....10). if existing, add it
                    
                    let data1 = site[pz].value(forKey: "image1")
                    
                    if(data1 != nil){
                    let image1 = UIImage(data: data1! as! Data)
                    
                    pageImages.append(image1!)
                    }
                    
                    let data2 = site[pz].value(forKey: "image2")
                    
                    if(data2 != nil){
                        let image2 = UIImage(data: data2! as! Data)
                        
                        pageImages.append(image2!)
                    }
                    
                    let data3 = site[pz].value(forKey: "image3")
                    
                    if(data3 != nil){
                        let image3 = UIImage(data: data3! as! Data)
                        
                        pageImages.append(image3!)
                    }
                    
                    let data4 = site[pz].value(forKey: "image4")
                    
                    if(data4 != nil){
                        let image4 = UIImage(data: data4! as! Data)
                        
                        pageImages.append(image4!)
                    }
                    
                    let data5 = site[pz].value(forKey: "image5")
                    
                    if(data5 != nil){
                        let image5 = UIImage(data: data5! as! Data)
                        
                        pageImages.append(image5!)
                    }
                    
                    let data6 = site[pz].value(forKey: "image6")
                    
                    if(data6 != nil){
                        let image6 = UIImage(data: data6! as! Data)
                        
                        pageImages.append(image6!)
                    }
                    
                    let data7 = site[pz].value(forKey: "image7")
                    
                    if(data7 != nil){
                        let image7 = UIImage(data: data7! as! Data)
                        
                        pageImages.append(image7!)
                    }
                    
                    let data8 = site[pz].value(forKey: "image8")
                    
                    if(data8 != nil){
                        let image8 = UIImage(data: data8! as! Data)
                        
                        pageImages.append(image8!)
                    }
                    
                    let data9 = site[pz].value(forKey: "image9")
                    
                    if(data9 != nil){
                        let image9 = UIImage(data: data9! as! Data)
                        
                        pageImages.append(image9!)
                    }
                    
                    let data10 = site[pz].value(forKey: "image10")
                    
                    if(data10 != nil){
                        let image10 = UIImage(data: data10! as! Data)
                        
                        pageImages.append(image10!)
                    }
   
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    
        //set number of pages
        let pageCount = pageImages.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount{
            pageViews.append(nil)
        }
        
        let pagesScrollViewSize = scroller.frame.size
        scroller.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
                                      height: pagesScrollViewSize.height)
        
        loadVisiblePages()
    }
    
    
    func loadPage(_ page: Int){
        if page<0 || page >= pageImages.count{
            return //outside range of what is to be displayed
        }
        
        if let pageView = pageViews[page]{
            pageView.isUserInteractionEnabled = true

            pageView.addGestureRecognizer(tapped)
            //do nothing, already loaded
        }else{
            var frame = scroller.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .scaleAspectFit
            newPageView.frame = frame
            newPageView.isUserInteractionEnabled = true
            
            //add "tapped" action
            newPageView.addGestureRecognizer(tapped)
            scroller.addSubview(newPageView)
            
            pageViews[page] = newPageView
            
        }
    }
    
    func loadVisiblePages(){
        // First, determine which page is currently visible
        let pageWidth = scroller.frame.size.width
        let page = Int(floor((scroller.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = 0
        let lastPage = pageControl.numberOfPages
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
}
