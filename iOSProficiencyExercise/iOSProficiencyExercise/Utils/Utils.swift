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
    static func resizeImage(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        var newSize = newSize
        let size: CGSize? = image?.size
        let widthRatio: CGFloat = newSize.width / (image?.size.width ?? 0.0)
        let heightRatio: CGFloat = newSize.height / (image?.size.height ?? 0.0)

        // Figure out what our orientation is, and use that to form the rectangle
        if widthRatio > heightRatio {
            newSize = CGSize(width: (size?.width ?? 0.0) * heightRatio, height: (size?.height ?? 0.0) * heightRatio)
        } else {
            newSize = CGSize(width: (size?.width ?? 0.0) * widthRatio, height: (size?.height ?? 0.0) * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: rect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}
