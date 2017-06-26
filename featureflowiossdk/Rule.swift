//
//  Rule.swift
//  Featureflow
//
//  Created by Max Mattini on 16/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation
import CryptoSwift

// TODO: MAX 26/06/2017 Should we reduce visibility of some of the methods and properties
public class Rule:NSObject {
    public static let ANONYMOUS:String = "anonymous"
    
    public var priority:Int?
    public var audience: Audience?
    public var variantSplits:[VariantSplit] = []

    override init(){
    }
    
    init?(dict:[String:Any]){
        if let obj = JsonHelper.nullToNil(value: dict["audience"] as AnyObject?), let dict = obj as? [String:Any] {
            audience = Audience(dict:dict)
        }
        if let variantSplitDictArray = dict["variantSplits"] as? [[String:Any]] {
            for variantSplitDict in variantSplitDictArray {
               let variantSplit = VariantSplit(dict:variantSplitDict)
               variantSplits.append(variantSplit!)
            }
        }
    }
    
    public  func matches(context: FeatureflowContext ) -> Bool {
        guard let audience = self.audience else {
            return true
        }
        return audience.matches(context: context)
    }
    
    override public var description : String {
        var out =  "Rule{\n" +
            "  priority='\(priority)'}\n"
        
        if let audience = self.audience {
            out = out + "Rule: \(audience)"
        } else {
           out = out + "Rule: No Audience\n"
        }
        if variantSplits.isEmpty {
            out = out + "Rule: No Variant Splits\n"
        } else {
            
            for variantSplit in variantSplits {
                out = out + "Rule: \(variantSplit)"
            }
        }
        return out
    }

    
    /**
     * Generate the Variant value using sha1hex
     * 1. We generate an equally distributed string of hex values, parse it to a length of 15,
     *      thats the max we can get before we blow out of the long range (fffffffffffffff)16 = (1152921504606846975)10
     * 2. We turn that hex into its representative number
     * 3. We find the remainder from 100 and use that as our variant bucket
     * @param contextKey - the contexts unique identifier key
     * @param featureKey - The feature key we are testing
     * @param salt - A salt value
     * @return hash - the hashed value
     */
    public  func getHash(contextKey:String , featureKey: String , salt: String ) -> String? {
        
        var hashStr = salt + ":" + featureKey + ":" + contextKey
        
        
        hashStr = hashStr.sha1()
        let index = hashStr.index(hashStr.startIndex, offsetBy: 15)
        hashStr = hashStr.substring(to: index)

        return hashStr
    }
    
    
    public func  getVariantValue(hash:String) -> Int64 {
        
        if let val = Int64(hash, radix: 16) {
            return (val % 100) + 1
        }
        return 0
        // ASSUMPTION: return 0 if cannot get value
    }

    public func getVariantSplitKey(contextKey: String? , featureKey:String , salt: String ) -> String? {

        let _contextKey = contextKey ?? Rule.ANONYMOUS
        
        let variantValue = getVariantValue(hash: getHash(contextKey: _contextKey, featureKey:featureKey, salt:salt)!)
        return getSplitKey(variantValue: variantValue)
    }
    
    public func getSplitKey(variantValue:Int64) -> String? {
        var percent:Int64 = 0;
        for  variantSplit in variantSplits {
            if let split = variantSplit.split {
                percent += split
                if percent >= variantValue {
                    return variantSplit.variantKey!
                }
            }
        }
        return nil
    }

}

/*
extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
 */



