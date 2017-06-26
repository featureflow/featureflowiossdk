//
//  VariantSplit.swift
//  Featureflow
//
//  Created by Max Mattini on 16/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation

public class VariantSplit:NSObject {
    
    public var variantKey:String?
    public var split: Int64?
    
    init(variantKey:String, split:Int64)
    {
        self.variantKey = variantKey
        self.split = split
    }
    
    init?(dict:[String:Any]){
        if let variantKey = dict["variantKey"] as? String {
            self.variantKey = variantKey
        }
        
        if let split = dict["split"] as? NSNumber {
            self.split = Int64(split)
        }
    }
    
    override public var description : String {
        let out =  "VariantSplit{\n" +
        "  split='\(split)'\n" +
        "  variantKey='\(variantKey)'}\n"
        
   
        return out
    }
    /*+
     //insert barely readable one-liner here:
     "  rules=" + rules.stream().map(r -> "Rule " + r.getPriority() + ": " + r.getVariantSplits().stream().map(s -> s.getVariantKey() + ":" + s.getSplit() +"% ").reduce("", String::concat) + "\n").reduce("", String::concat) + "\n" +
     
     "  variants=" + (variants==null?null:variants.stream().map(v -> v.name +" ").reduce("", String::concat)) + "\n" +
     '}'*/

    
}
