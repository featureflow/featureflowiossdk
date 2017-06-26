//
//  RuleVariantsTest.swift
//  Featureflow
//
//  Created by Max Mattini on 21/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import XCTest

@testable import featureflowiossdk
class RuleVariantsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultOnVariant()  {
        
        let rule =  Rule()
        let onId = "onId"
        let offId = "ioffId"
        rule.variantSplits = [ VariantSplit(variantKey:onId, split:100),  VariantSplit(variantKey:offId, split:0)]
        
        XCTAssertEqual(onId, rule.getVariantSplitKey(contextKey: "oliver", featureKey: "f1", salt: "1"))
    }
    
    
    func testDefaultOffVariant()  {
        let rule =  Rule()
        let onId = "onId"
        let offId = "ioffId"
        rule.variantSplits = [ VariantSplit(variantKey:onId, split:0),  VariantSplit(variantKey:offId, split:100)]
        
        XCTAssertEqual(offId, rule.getVariantSplitKey(contextKey: "oliver", featureKey: "f1", salt: "1"))
    }
    
    func testMultiVariant()  {
        
        let rule =  Rule()
        let id1 = "id1"
        let id2 = "id2"
        let id3 = "id3"
        rule.variantSplits = [ VariantSplit(variantKey:id1, split:10),  VariantSplit(variantKey:id2, split:60), VariantSplit(variantKey:id3, split:30)]
        
        XCTAssertEqual(id1, rule.getVariantSplitKey(contextKey: "oliver", featureKey: "f1", salt: "1"))
        XCTAssertEqual(id2, rule.getVariantSplitKey(contextKey: "alan", featureKey: "f1", salt: "1"))
        XCTAssertEqual(id2, rule.getVariantSplitKey(contextKey: "sarah", featureKey: "f1", salt: "1"))
    }
    
    
    // NOTE this test has no assertion. Same as Java test
    func testGetVariantValue(){
        let values = [
            "alice",
            "bob",
            "charlie",
            "daniel",
            "emma",
            "frank",
            "george"]
        
        let seeds = ["1","2","3"]
        
        for  seed in seeds {
            print("SEED is " + seed);
            for  value in values {
                let rule =  Rule()
                let hash = rule.getHash(contextKey: value, featureKey: "f1", salt: seed)
                let variantValue = rule.getVariantValue(hash: hash!)
                print("\(value) equals \(variantValue)")
            }
        }
        
    }
    
    
}
