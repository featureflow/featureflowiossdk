//
//  Audience.swift [UTR]
//  Featureflow
//
//  Created by Max Mattini on 19/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation
public class Audience:NSObject{
    var id:String? = nil
    var name:String? = nil
    var conditions:[Condition] = []

    init(id:String? , name:String? ,conditions:[Condition]) {
        self.id = id;
        self.name = name;
        self.conditions = conditions;
    }
    
    init?(dict:[String:Any]){
        
        if let obj = JsonHelper.nullToNil(value: dict["id"] as AnyObject?), let val = obj as? String {
            self.id = val
        }
        if let obj = JsonHelper.nullToNil(value: dict["name"] as AnyObject?), let val = obj as? String {
            self.name = val
        }
        if let conditionDictArray = dict["conditions"] as? [[String:Any]] {
            for conditionDict in conditionDictArray {
                if let condition = Condition(dict:conditionDict) {
                    conditions.append(condition)
                }
            }
        }
    }
    
    //check that all conditions match (it is an AND - to do an OR you would effectively use the 'is in' operator)
    public func matches(context: FeatureflowContext ) -> Bool {
        guard !conditions.isEmpty else {
            return true
        }
        for  condition in conditions {
            if !condition.matches(context: context){
                return false;
            }
        }
        return true
    }
    
    override public var description : String {
        var out  = "Audience{\n" +
         "  id='\(id)'\n" +
         "  name='\(name)'}\n"
        
        if conditions.isEmpty {
            out = out + "Audience[\(name)]: No Variant Splits\n"
        } else {
            for condition in conditions {
                out = out + "Audience[\(name)]: \(condition)"
            }
        }
        return out
    }
}
