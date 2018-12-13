//
//  DetailViewController.swift
//  cosmos
//
//  Created by William Yang on 12/10/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import UIKit

/**
 DetailViewController displays selftext of post selected from ExploreViewController
 */
class DetailViewController: UIViewController {

    @IBOutlet weak var selftextTextView: UITextView!
    
    var selftext: String = ""
    var postTitle: String = ""
    
    // see apple documentation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = postTitle
        if (selftext.trimmingCharacters(in: .whitespaces) != ""){
            selftextTextView.text = selftext
        } else {
            selftextTextView.text = STRINGS.emptyBody
        }        
    }
}
