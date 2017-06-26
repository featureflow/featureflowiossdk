//
//  FeatureflowContext.swift
//  Featureflow
//
//  Created by Max Mattini on 19/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation

public class FeatureflowContext {
    
    public  let  FEATUREFLOW_KEY = "featureflow.key"
    public  let  FEATUREFLOW_DATE = "featureflow.date"
    public  let  FEATUREFLOW_HOUROFDAY = "featureflow.hourofday"

    public var values = [String : Any]()
    public var key:String?
    
    init(key:String, values: [String: Any]?){
        self.key = key
        self.values[FEATUREFLOW_KEY] = key
        if let _values = values {
            for (key, value) in _values {
                self.values[key] = value
            }
        }
    }
    
    public static func keyedContext(key:String) -> Builder {
        return  Builder(key:key)
    }
    
    public static func context() -> Builder{
        return Builder(key: nil)
    }
    
    public class Builder{
        private var key:String
        private var values = [String : Any]()
        
        public init(key:String?) {
            if let key = key {
                self.key = key
            } else {
                self.key = "anonymous"
            }
        }
        
        // Used when calue is a number, string, etc...
        public func withValue(key:String, value:Any) -> Builder {
            self.values[key] = value
            return self
        }
        
        public func withValue(key:String, date:Date) -> Builder {
            self.values[key] = Builder.toIso(date: date)
            return self
        }

        public func withDateValues(key:String, dates:[Date])-> Builder{
            var isoDates = [String]()
       
            for date in dates {
                isoDates.append(Builder.toIso(date: date))
            }
        
           self.values[key] =  isoDates
           return self
        }
        
        // Can be used for number and string
        public func  withValues(key:String, values:[Any]) -> Builder{
            self.values[key] =  values
            return self
        }
        
        public func build() -> FeatureflowContext{
            return  FeatureflowContext(key:key, values:values)
        }
        
        public static func toIso(date: Date) -> String {
            return date.iso8601
        }
        
        public static func fromIso(isoDate:String)-> Date{
            return isoDate.dateFromISO8601!
        }
    }
    
}
