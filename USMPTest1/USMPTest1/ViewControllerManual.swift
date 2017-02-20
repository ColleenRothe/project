//
//  ViewControllerManual.swift
//  USMPTest1
//
//  Created by Colleen Rothe on 11/13/15.
//  Copyright © 2015 Colleen Rothe. All rights reserved.
//

import UIKit


class ViewControllerManual: UIViewController, UIDocumentInteractionControllerDelegate {
    
    //webview for pdf
    @IBOutlet weak var manualView: UIWebView!
    //title
    @IBOutlet weak var headerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        previewDocument();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func previewDocument(){
        //path to find rating manual
        let urlpath = Bundle.main.path(forResource: "RatingManual", ofType: "pdf")
        //let url:NSURL = NSURL.fileURLWithPath(urlpath!)
        
        //load rating manual
        manualView.loadRequest(URLRequest(url: URL(fileURLWithPath: urlpath!)))
        
        //enable interaction with web view
        manualView.isUserInteractionEnabled = true
        
        //enable scrolling
        manualView.scrollView.isScrollEnabled = true
        
        
        
    }
  
}


    
    
    
