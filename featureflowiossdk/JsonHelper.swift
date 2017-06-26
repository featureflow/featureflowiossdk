//
//  JsonHelper.swift
//  Featureflow
//
//  Created by Max Mattini on 19/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation

class JsonHelper
{
    static func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value // including nil
        }
    }
    
    static func isNullOrNil(value : AnyObject?) -> Bool {
        if value is NSNull {
            return true
        }
        return value == nil
    }
    
    static func isNull(value : AnyObject?) -> Bool {
        if value is NSNull {
            return true
        }
        return false
    }
}
