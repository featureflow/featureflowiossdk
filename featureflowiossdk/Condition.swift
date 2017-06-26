//
//  Condition.swift
//  Featureflow
//
//  Created by Max Mattini on 19/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved. [UTR]
//

import Foundation

public class Condition:NSObject
{
    var target:String?    //name, age, date
    var op: Operator? // = < > like in out. NOTE: 'operator' is a keyword in swift
    var values: [Any] = [] //some value 1,2,dave,timestamp,2016-01-11-10:10:10:0000UTC
    
    init(target:String , op: Operator , values:[Any]) {
        self.target = target;
        self.op = op;
        self.values = values;
    }
    
    init?(dict:[String:Any]){
        if let obj = JsonHelper.nullToNil(value: dict["operator"] as AnyObject?), let val = obj as? String {
            self.op = Operator.fromString(str: val)
        }
        if let obj = JsonHelper.nullToNil(value: dict["target"] as AnyObject?), let val = obj as? String {
            self.target = val
        }
        if let valueArray = dict["values"] as? [Any] {
            for v in valueArray {
                values.append(v)
            }
        }
    }

    override public var description : String {
        var out =  "Condition{\n" +
        "  target='\(target)'\n" +
        "  op='\(op)'}\n"
        
        if values.isEmpty {
            out = out + "Condition[\(op)]: No values\n"
        } else {
            
            for value in values {
                out = out + "Condition[\(op)]:  value= \(value)\n"
            }
        }
        return out
    }

    public func matches(context:FeatureflowContext?) -> Bool {
        //see if context contains target
        guard let context = context, !context.values.isEmpty else {
            return false  // ASSUMPTION: here nil values is same as empty values
        }
        if let target = self.target {
            for key in context.values.keys {
                if(key == target){
                    //compare the value using the comparator
                    if let ar = context.values[key] as? [Any] {
                        
                        for  jsonElement in ar {//return true if any of the list of context values for the key matches
                            if (op?.evaluate(contextValue: jsonElement, targetValues: values))! {
                                return true;
                            }
                        }
                        return false; //else return false
                    }
                    if let contextValue = context.values[key] {
                        return (op?.evaluate(contextValue: contextValue, targetValues: self.values))!
                    }
                }
            }
        }
        return false
    }
    
}
