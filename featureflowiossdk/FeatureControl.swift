//
//  FeatureControl.swift
//  Featureflow
//
//  Created by Max Mattini on 16/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation

public class FeatureControl:NSObject {
    
    public var id:String? // The internal unique identifier for this feature control
    public var featureId: String?
    public var key: String  //the key which is unique per project and used as the human-readable unique key
    public var environmentId: String?  //the environmentId
    public var salt:String = "1" //The salt is used to hash context details (this is in the environment config)  TBC
    public var enabled: Bool? //is this feature enabled? If not then we show the offVariant
    public var available: Bool? //is the feature available in the environment?
    public var deleted: Bool? //has this been deleted then ignore in all evaluations
    public var offVariantKey :String?  // This is served if the feature is toggled off and is the last call but one (the coded in value is the final failover value)
    public var inClientApi: Bool?  //is this in the JS api (for any required logic)
    public var variants = [Variant]()  //available variants for this feature
    public var rules = [Rule]() //A list of feature rules which contain rules to target /*xxx*/public variant splits at particular audiences
    
    /* TODO: Max 26/06/2017 What to do with values below. They are sent but not used
         archived = 0;
         firstRegistered = "<null>";
         hitsToday = "<null>";
         lastEvaluated = "<null>";
         lastRegistered = "<null>";
         organisationId = 5943339c81608a000b0bbe63;
         projectId = 5943339e81608a000b0bbe66;
         status = unavailable;
         uid = "<null>";
     */
    
     init(key:String){
        self.key = key
    }
    
    init?(key:String, dict:[String:Any]){
        self.key = key
        
        if let available = dict["available"] as? Bool {
            self.available = available
        }
        if let deleted = dict["deleted"] as? Bool {
            self.deleted = deleted
        }
        if let enabled = dict["enabled"] as? Bool {
            self.enabled = enabled
        }
        if let environmentId = dict["environmentId"] as? String {
            self.environmentId = environmentId
        }
        if let featureId = dict["featureId"] as? String {
            self.featureId = featureId
        }
        if let offVariantKey = dict["offVariantKey"] as? String {
            self.offVariantKey = offVariantKey
        }
        if let id = dict["id"] as? String {
            self.id = id
        }
        if let inClientApi = dict["inClientApi"] as? Bool {
            self.inClientApi = inClientApi
        }
        if let salt = dict["salt"] as? String {
            self.salt = salt
        }
        if let offVariantKey = dict["offVariantKey"] as? String {
            self.offVariantKey = offVariantKey
        }
    
        if let variantDictArray = dict["variants"] as? [[String:Any]] {
            for variantDict in variantDictArray {
                let variant = Variant(dict:variantDict)
                variants.append(variant!)
            }
        }
    
        if let ruleDictArray = dict["rules"] as? [[String:Any]] {
            for ruleDict in ruleDictArray {
                let rule = Rule(dict:ruleDict)
                rules.append(rule!)
            }
        }
    }
    
    
    public func evaluate(context: FeatureflowContext ) -> String? {
        
        guard let enabled = self.enabled else {
            return self.offVariantKey //ASSUMPTION: if enabled is not set it is equivalent to not enabled
        }
        
        if !enabled {
            return self.offVariantKey
        }
        
        //if we have rules (we should always have at least one - the default rule
        for  rule in self.rules {
            if rule.matches(context: context) {
                //if the rule matches then pass back the variant based on the split evaluation
                return rule.getVariantSplitKey(contextKey: context.key, featureKey: self.key,salt: salt);
            }
        }
        return nil //at least the default rule above should have matched, if not, return null to invoke using the failover rule
    }
    
    
    override public var description : String {
        
        var out = "FeatureControl{\n" +
            "  key='\(key)'\n" +
            "  environmentId='\(environmentId)'\n" +
            "  enabled=\(enabled)\n" +
            "  available=\(available)\n" +
            "  deleted=\(deleted)\n" +
            "  offVariantKey=\(offVariantKey)\n" +
            "  inClientApi=\(inClientApi)}\n"
        
        if rules.isEmpty {
            out = out + "FeatureControl[\(key)]: No rules\n"
        } else {
            
            for rule in rules {
                out = out + "FeatureControl[\(key)]: \(rule)"
            }
        }
        
        if variants.isEmpty {
            out = out + "FeatureControl[\(key)]: No variants\n"
        } else {
            for variant in variants {
                out = out + "FeatureControl[\(key)]: \(variant)"
            }
        }
    
        return out
    }
}
