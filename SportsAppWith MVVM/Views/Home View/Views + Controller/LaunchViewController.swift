//
//  LaunchViewController.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var GifLoad: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        GifLoad.loadGif(name: "launch")
        
        // .now()+1.54
        DispatchQueue.main.asyncAfter(deadline: .now()+2.6) {
            let story = UIStoryboard(name: "HomeMain", bundle: nil)
            let next  = story.instantiateViewController(withIdentifier: "HomeViewController")
            next.modalPresentationStyle = .fullScreen
            next.modalTransitionStyle   = .partialCurl
            self.present(next, animated: true)
        }
    }

}
