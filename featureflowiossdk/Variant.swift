//
//  Variant.swift
//  Featureflow
//
//  Created by Max Mattini on 20/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation

public class Variant:NSObject {

    
    public static let  off = "off"
    public static let  on = "on"
    public var key:String? //unique key - true/false/blue/green or another feature
    public var name: String? //the value of the variant
    
    
    init(key:String, name:String)
    {
        self.key = key
        self.name = name
    }
    
    init?(dict:[String:Any]){
        if let key = dict["key"] as? String {
            self.key = key
        }
        
        if let name = dict["name"] as? String {
            self.name = name
        }
    }
    
    override public var description : String {
        return "Variant{\n" +
        "  key='\(key)'\n" +
        "  name='\(name)'}\n"
    }
}
