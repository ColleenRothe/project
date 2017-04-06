//
//  Credits.swift
//  USMPTest1
//
//  Credits page showing images for all of the affiliated groups
//
//  Created by Colleen Rothe on 3/7/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//CREDITS:
//https://stackoverflow.com/questions/30440660/start-uiscrollview-with-an-image-of-particular-index-from-another-view
//https://www.raywenderlich.com/122139/uiscrollview-tutorial

import UIKit

class Credits: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scroller: UIScrollView!
  
    @IBOutlet weak var pageControl: UIPageControl!
    
    var pageImages: [UIImage] = [] //hold all images to display
    var pageViews: [UIImageView?] = [] //hold instances of UIImageView to display each image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    func loadImages(){
        //get all of the images
        let ibaImage = UIImage(named: "BureaOfIndianAffairs(BIA)")
        let blmImage = UIImage(named: "BureauOfLandManagement(BLM)")
        let fhaImage = UIImage(named: "FederalHighwayAdministration(FHWA)")
        let nfsImage = UIImage(named: "NationalForestService(NFS)")
        let npsImage = UIImage(named: "NationalParkService(NPS)")
        let wflImage = UIImage(named: "WesternFederalLandsHighway(WFL)")
        let aceImage = UIImage(named: "ArmyCoreOfEngineers(USACE)")
        let usbrImage = UIImage(named: "BureauOfReclamation(USBR)")
        let wtiImage = UIImage(named: "WesternTransportationInstitute(WTI)")
        let ccImage = UIImage(named: "ConforthConsultants")
        let msuImage = UIImage(named: "MontanaStateUniversity(MSU)")

        //add them to the array
        pageImages = [ibaImage!, blmImage!, fhaImage!, nfsImage!, npsImage!, wflImage!, aceImage!, usbrImage!, wtiImage!, ccImage!, msuImage!]
    
        //# of images
        let pageCount = pageImages.count
        //what page are you at?
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount{
            pageViews.append(nil)
        }
        //set sizing
        let pagesScrollViewSize = scroller.frame.size
        scroller.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        loadVisiblePages()
    }
    
    //load page
    func loadPage(_ page: Int){
        if page<0 || page >= pageImages.count{
            return //outside range of what is to be displayed
        }
        
        if pageViews[page] != nil{
            //do nothing, already loaded
        }else{
            var frame = scroller.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            var newPageView = UIImageView()
            newPageView.contentMode = .scaleAspectFit
            //put image into view
            newPageView = UIImageView(image: pageImages[page])
             newPageView.frame = frame
            //add it to the scrolling page
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
        let lastPage = 11
        
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
