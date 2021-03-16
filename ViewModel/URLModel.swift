//
//  URLModel.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 08/07/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import Foundation
import UIKit

class HightLightURLData {
    
    let highLightedURL:String
    init(highLightedURL:String) {
        self.highLightedURL = highLightedURL
    }
    
}

class SocialMediaURLData {
    let url:String
    let socialMediaIconName:String
    
    init(url:String, socialMediaIconName:String) {
        self.url = url
        self.socialMediaIconName = socialMediaIconName
    }
}
