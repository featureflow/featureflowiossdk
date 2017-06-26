//
//  Operator.swift
//  Featureflow
//
//  Created by Max Mattini on 19/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation


public enum Operator: String
{
    case equals
    case testRuleEquals
    case lessThan
    case greaterThan
    case greaterThanOrEqual
    case lessThanOrEqual
    case startsWith
    case endsWith
    case matches
    case inOperator
    case notIn
    case contains
    case before
    case after
    
    static func fromString(str:String) -> Operator {
        if str == "in" {
            return .inOperator
        } else {
            return Operator(rawValue:str)!
        }
    }
    
    func evaluate(contextValue: Any,  targetValues:[Any]? ) -> Bool{
        guard let targetValues =  targetValues, !targetValues.isEmpty else  {
            switch self {
            case .inOperator: return false
            case .notIn: return true
            default: return false
            }
        }
        switch self {
        case .equals:
            if  let number = contextValue as? NSNumber, let targetNumber = targetValues[0] as? NSNumber {
                let res =  number == targetNumber
               return res
            }
            if  let str = contextValue as? String, let targetStr = targetValues[0] as? String {
                return  (str == targetStr)
            }
            //TODO: MAX 26/06/2107 should we implement other types?
            return true
        case .testRuleEquals,.greaterThan:
            // QUESTION: what .testRuleEquals does?
            if  let number = contextValue as? NSNumber, let targetNumber = targetValues[0] as? NSNumber{
                let numberAsDouble = number.doubleValue
                let targetNumberAsDouble = targetNumber.doubleValue
                return numberAsDouble > targetNumberAsDouble
            }
        case .lessThan:
            if  let number = contextValue as? NSNumber, let targetNumber = targetValues[0] as? NSNumber {
                let numberAsDouble = number.doubleValue
                let targetNumberAsDouble = targetNumber.doubleValue
                return numberAsDouble < targetNumberAsDouble
            }
        case .greaterThanOrEqual:
            if  let number = contextValue as? NSNumber, let targetNumber = targetValues[0] as? NSNumber {
                let numberAsDouble = number.doubleValue
                let targetNumberAsDouble = targetNumber.doubleValue
                return numberAsDouble >= targetNumberAsDouble
            }
        case .lessThanOrEqual:
            if  let number = contextValue as? NSNumber, let targetNumber = targetValues[0] as? NSNumber {
                let numberAsDouble = number.doubleValue
                let targetNumberAsDouble = targetNumber.doubleValue
                return numberAsDouble <= targetNumberAsDouble
            }
        case .startsWith:
            if  let str = contextValue as? String, let targetStr = targetValues[0] as? String {
                return str.hasPrefix(targetStr)
            }
        case .endsWith:
            if  let str = contextValue as? String, let targetStr = targetValues[0] as? String {
                return str.hasSuffix(targetStr)
            }
        case .matches:
            if  let str = contextValue as? String, let targetStr = targetValues[0] as? String {
                do {
                    let regex = try NSRegularExpression(pattern: targetStr)
                    let results = regex.matches(in: str, range: NSRange(location: 0, length: str.characters.count))
                    return (!results.isEmpty)
                } catch let error {
                    print("invalid regex: \(error.localizedDescription)")
                    return false
                }
            }
        case .inOperator:
            let number = contextValue as? NSNumber
            let str = contextValue as? String
            for  targetValue in targetValues {
                // TODO: MAX 26/06/2107 should we implement other types?
                // QUESTION: For Double should we allow for some distance
                if  number != nil, let targetNumber = targetValue as? NSNumber{
                    if  number == targetNumber {
                        return true
                    }
                }
                if  str != nil, let targetStr = targetValue as? String {
                    if  str == targetStr {
                        return true
                    }
                }
            }
            return false
        case .notIn:
            let number = contextValue as? NSNumber
            let str = contextValue as? String
            for  targetValue in targetValues {
                // TODO: MAX 26/06/2107 should we implement other types?
                if  number != nil, let targetNumber = targetValue as? NSNumber {
                    if  number == targetNumber {
                        return false
                    }
                }
                if  str != nil, let targetStr = targetValue as? String {
                    if  str == targetStr {
                        return false
                    }
                }
            }
            return true
        case .contains:
            if  let contextValueAsStr = contextValue as? String, let targetStr = targetValues[0] as? String {
                return contextValueAsStr.contains(targetStr)
            }
        case .before:
            if let contextValueAsDate = getDateTime(valueAsAny:contextValue), let targetAsDate = getDateTime(valueAsAny: targetValues[0]) {
                return contextValueAsDate < targetAsDate
                // QUESTION: What about if equal
             }
        case .after:
            if let contextValueAsDate = getDateTime(valueAsAny:contextValue), let targetAsDate = getDateTime(valueAsAny: targetValues[0] ) {
                return contextValueAsDate > targetAsDate
                // QUESTION: What about if equal
            }
        }
        return false
    }
    
    func getDateTime(valueAsAny:Any?) -> Date?
    {
        guard let valueAsAny = valueAsAny else {
            return nil
        }
        if  let valueAsNumber = valueAsAny as? NSNumber {
            // /// Returns a `Date` initialized relative to 00:00:00 UTC on 1 January 1970 by a given number of seconds.
            return Date(timeIntervalSince1970: valueAsNumber as TimeInterval)
            // ASSUMPTION: I am using 'timeIntervalSince1970' as reference date
        }
        if  let valueAsStr = valueAsAny as? String {
            
            return valueAsStr.dateFromISO8601
        }
        return nil
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        //formatter.locale = Locale(identifier: "en_US_POSIX") 
        // QUESTION: What locale we should use
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
       
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                             // 2016-11-20T20:36:19Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}


