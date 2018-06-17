//
//  Utils.swift
//  iOSProficiencyExercise
//
//  Created by Hardik on 6/17/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import UIKit
class Utils: NSObject {
    enum UIUserInterfaceIdiom : Int {
        case unspecified
        case iPhone // iPhone and iPod touch style UI
        case iPad // iPad style UI
    }
    static func deviceType() ->(UIUserInterfaceIdiom)
    {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            return .iPhone
        case .pad:
            return .iPad
        // It's an iPad
        default: break
            // Uh, oh! What could it be?
        }
        return .iPhone
    }
    static func showAlert(title : String,Message message: String,buttonText text:String,viewController view:UIViewController )
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: text, style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
}
