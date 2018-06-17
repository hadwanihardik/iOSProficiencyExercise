//
//  Utils.swift
//  iOSProficiencyExercise
//
//  Created by Hardik on 6/17/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import UIKit
class Utils: NSObject {

    // Device familu enum
    enum deviceFamily : Int {
        case unspecified
        case iPhone
        case iPad
    }
    //Check and return device type
    static func deviceType() ->(deviceFamily)
    {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        default: break
        }
        return .unspecified
    }
    //Common method to show alert
    static func showAlert(title : String,Message message: String,buttonText text:String,viewController view:UIViewController )
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: text, style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }

    // Function to resize image based on passed parameters and ratio of image
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
