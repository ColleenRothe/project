//
//  ManualRating.swift
//  USMPTest1
//
//  Page to show rating manual while on one of the rating forms
//
//  Created by Colleen Rothe on 6/6/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

import Foundation
import UIKit

class ManualRating: UIViewController, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var manualView: UIWebView!
    
    let shareData = ShareData.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        previewDocument();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func previewDocument(){
        //path to find rating manual
        let urlpath = Bundle.main.path(forResource: "RatingManual", ofType: "pdf")
        
        //load rating manual
        manualView.loadRequest(URLRequest(url: URL(fileURLWithPath: urlpath!)))
        
        //enable interaction with web view
        manualView.isUserInteractionEnabled = true
        
        //enable scrolling
        manualView.scrollView.isScrollEnabled = true
        
        manualView.scalesPageToFit = true
 
    }
}
