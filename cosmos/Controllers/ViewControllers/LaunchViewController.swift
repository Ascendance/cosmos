//
//  LaunchViewController.swift
//  cosmos
//
//  Created by William Yang on 12/10/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import UIKit

/**
 Designed as a 'second LaunchScreen' to indicate loading/progress
 */
class LaunchViewController: UIViewController {

    @IBOutlet weak var launchProgressBar: UIProgressView!
    
    // see apple documentation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(CONFIG.debug){
            NSLog("Launched in debug with server: \(CONFIG.server)")
        } else {
            NSLog("Launched with server: \(CONFIG.server)")
        }
        
        NetworkController.testConnection(destination: CONFIG.testURL, completion: { response in
            if(response == -1){
                Tools.displayAlert(vc: self, title: STRINGS.connectionFailedTitle, body: STRINGS.connectionFailedBody)
            } else {
                self.launchProgressBar.setProgress(Float(1), animated: true)
                DispatchQueue.global(qos: .background).async {
                    sleep(2)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "LaunchSegue", sender: self)
                    }
                }
            }
        })
    }
}
