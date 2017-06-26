//
//  Feature.swift
//  Featureflow
//
//  Created by Max Mattini on 21/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation


public class Feature {
    public var variants:[Variant]?
    public let key:String
    public let failoverVariant:String
    
    
    public init(key:String , variants:[Variant]?,  failoverVariant:String?) {
        self.key = key
        self.variants = variants
        if let failoverVariant = failoverVariant {
            self.failoverVariant = failoverVariant
        } else {
            self.failoverVariant = Variant.off
        }
    }
}
