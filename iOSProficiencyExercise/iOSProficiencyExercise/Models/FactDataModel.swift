//
//  FactDataModel.swift
//  iOSProficiencyExercise
//
//  Created by Hardik on 6/17/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import UIKit

class FactDataModel: NSObject {

    var title : String = "There is no title for this fact"
    var details : String = "There are no details for this fact"
    var imageUrl : String = ""

    init(dictInfo:[String:Any])
    {
        super.init()
        if let ttl =  dictInfo["title"] as? String {
            self.title = ttl ;
        }
        if let desc =  dictInfo["description"] as? String {
            self.details = desc;
        }
        if let desc =  dictInfo["imageHref"] as? String{
            self.imageUrl = desc;
        }
    }
}
