//
//  RequestSignUp.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 1/8/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation
import Mantle

class RequestSignUp: MTLModel, MTLJSONSerializing {
    
    var emailId:String = ""
    var userType:String = ""
    
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["emailId" : "email", "userType" : "user_type"]
    }
    
}
