//
//  YoutubeViewController.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import UIKit
import WebKit

class YoutubeViewController: UIViewController {

    @IBOutlet weak var myWebKit: WKWebView!
        
        var youtubeLink = String()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            print("F: \(youtubeLink)")
            
            ShowLink()
            
        }
        
        @IBAction func BTNBack (_ sender:Any) {
            self.dismiss(animated: true, completion: nil)
        }
        
        @IBAction func BTNReferesh (_ sender:Any) {
            ShowLink()
        }
        
        func ShowLink() {
            youtubeLink = "https://\(youtubeLink)"
            
            //myWebKit.load(NSURLRequest(url: NSURL(string: youtubeLink)! as URL) as URLRequest)
            let request = URLRequest(url: URL(string: youtubeLink)!)
            myWebKit.load(request)
        }

}
