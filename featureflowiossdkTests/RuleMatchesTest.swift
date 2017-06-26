//
//  RuleMatchesTest.swift
//  Featureflow
//
//  Created by Max Mattini on 21/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import XCTest


@testable import featureflowiossdk
class RuleMatchesTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRuleEquals() {
        let rule =  Rule()
        let c1 = Condition(target:"name", op:Operator.equals, values:["oliver"])
        let a =  Audience(id:nil, name:nil,conditions: [c1])
        rule.audience = a
        
        let context =  FeatureflowContext(key: "oliver", values: ["name": "oliver"])
        XCTAssertTrue(rule.matches(context: context))
    }
    
    
    func testMultipleConditionsMustAllMatch() {
        
        let rule =  Rule()
        let c1 = Condition(target:"tier", op:Operator.equals, values:["gold"])
        let c2 = Condition(target:"name", op:Operator.equals, values:["oliver"])
        let a =  Audience(id:nil, name:nil,conditions: [c1,c2])
        rule.audience = a
        
        let context =  FeatureflowContext(key: "oliver", values: ["tier":"silver", "name": "oliver"])
        XCTAssertFalse(rule.matches(context:context))
        
    }
    
    func testRuleGreaterThan()  {
        let rule =  Rule()
        let c1 = Condition(target:"age", op:Operator.greaterThan, values:[25])
        let a =  Audience(id:nil, name:nil,conditions: [c1])
        rule.audience = a
        
        let context =  FeatureflowContext(key: "oliver", values: ["name": "oliver","age": 26])
        XCTAssertTrue(rule.matches(context: context))
    }
    
    
    func testRuleMatchesWithNullAudience()  {
        let rule =  Rule()
        
        // Note: Condition is not used. Same as in Java test
        let _ = Condition(target:"age", op:Operator.greaterThan, values:[25])
        
        let context =  FeatureflowContext(key: "oliver", values: ["name": "oliver","age": 26])
        XCTAssertTrue(rule.matches(context: context))
        
    }
    
    
}
