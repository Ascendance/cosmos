//
//  Tools.swift
//  cosmos
//
//  Created by William Yang on 12/10/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import UIKit

/**
 Collection of helper tools for this app
 */
class Tools{
    
    /**
     displays a standard alert dialog
     - Parameter vc: calling viewController (UIViewController)
     - Parameter title: title of the dialog (String)
     - Parameter body: body of the dialog (String)
     */
    static func displayAlert(vc: UIViewController, title: String, body: String){
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}



