//
//  ApiClient.swift
//  iOSProficiencyExercise
//
//  Created by Hardik on 6/17/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import Foundation

class ApiClient: NSObject {

   static func callingWebserviceUsingNSUrlConnection(url:String,postCompleted: @escaping ( _ status : Bool, _ dictData:[String:AnyObject]) -> ())
    {
        let url = URL(string: url)
        var urlRequest: URLRequest? = nil
        if let anUrl = url {
            urlRequest = URLRequest(url: anUrl)
        }
        let queue = OperationQueue()
        if let aRequest = urlRequest {
            NSURLConnection.sendAsynchronousRequest(aRequest, queue: queue, completionHandler: { response, data, error in
                if error != nil {
                    //NSLog(@"Error,%@", [error localizedDescription]);
                } else {
                    let string = String(data: data!, encoding: .isoLatin1) ?? ""
                    let utf8Data = Data(string.utf8)
                    do {
                        //Check and return if Json proper than return proper response or return error.
                        if let json = try JSONSerialization.jsonObject(with: utf8Data, options : .allowFragments) as? [String : Any]{
                            postCompleted(true,json as [String : AnyObject])
                        }else{
                            print("Error while encoding")
                            postCompleted(false,["error":"Error while encoding" as AnyObject])

                        }
                    } catch let error as NSError {
                        print(error)
                        postCompleted(false,["error":error.description as AnyObject])
                    }
                }
            })
        }


    }
}


