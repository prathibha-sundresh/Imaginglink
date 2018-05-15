//
//  StringExtension.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 1/8/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

public extension String {
    var lenght:Int {
        get {
            return self.count
        }
    }
    
    func subString(to : Int) -> String? {
        if(to >= lenght) {
            return nil
        }
        
        return " "
//        let toIndex = self.index(self.startIndex, offsetBy: to)
//        return self.subString(to: toIndex)
    }
    
}

