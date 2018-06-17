//
//  ApiClient.swift
//  iOSProficiencyExercise
//
//  Created by Hardik on 6/17/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import Alamofire

class ApiClient: NSObject {
    static func GetAPI(url:String,postCompleted: @escaping ( _ status : Bool, _ dictData:[String:AnyObject]) -> ())
    {
        //Creat Url request based on url passed
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(request).validate().responseString { (string) in
            //We are getting data in latin1 format so converting it from latin to utf8 because latin1 does not serialize properly
            let string = String(data: string.data!, encoding: .isoLatin1) ?? ""
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
    }
}
