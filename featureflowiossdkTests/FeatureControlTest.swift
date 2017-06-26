//
//  FeatureControlTest.swift
//  Featureflow
//
//  Created by Max Mattini on 21/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import XCTest

@testable import featureflowiossdk
class FeatureControlTest: XCTestCase {
    
    let RED = "red"
    let BLUE = "blue"
    let JOHN = "john"
    let NAME = "name"
    let USER_KEY = "userKey"
    let ROLE = "role"
    let TESTER = "tester"
    let END_USER = "endUser"
    let TESTER1 = "tester"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEvaluate()   {
        
        //create feature and variant
        let featureControl =  FeatureControl(key: "FF-01")
        featureControl.enabled = true
        
        let red =  Variant(key:RED, name:RED)
        let blue =  Variant(key:BLUE, name:BLUE)
        featureControl.variants = [red, blue]
        
        //create one rule with an audience
        let rule1 =  Rule()
        let condition =  Condition(target:ROLE, op:Operator.equals, values:[TESTER])
        let audience =  Audience(id:nil, name:nil,conditions: [condition])
        
        rule1.audience = audience
        rule1.priority = 2
        rule1.variantSplits = [ VariantSplit(variantKey:RED, split:0),  VariantSplit(variantKey:BLUE, split:100)]
        
        // create default rule
        let rule2 =  Rule()
        rule2.priority = 1
        rule2.variantSplits = [ VariantSplit(variantKey:RED, split:100),  VariantSplit(variantKey:BLUE, split:0)]
        
        featureControl.rules = [rule1,rule2]
        
        var context =  FeatureflowContext(key: USER_KEY, values:[ROLE:TESTER])
        var status = featureControl.evaluate(context:context)
        XCTAssertEqual(BLUE, status) //Blue as we are ROLE TSETER
        
        context =  FeatureflowContext(key: USER_KEY, values:[ROLE:END_USER])
        status = featureControl.evaluate(context:context)
        XCTAssertTrue(status == RED)
    }
    
    
    func testReadFromFile()   {
        
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "testData", ofType: "json") else {
            XCTFail("cannot find test file")
            return
        }
        
        let ex = expectation(description: "expectation")
        Store.sharedInstance.readFeaturesFromFile(path: path){
            (featureControls, error) in
            
            XCTAssertEqual(6, featureControls.keys.count,  "expecting 6 feature controls")
            XCTAssertNotNil(featureControls["something"])
            XCTAssertNotNil(featureControls["summary-dashboard"])
            XCTAssertNotNil(featureControls["facebook-login"])
            XCTAssertNotNil(featureControls["example-feature"])
            XCTAssertNotNil(featureControls["feature1"])
            XCTAssertNotNil(featureControls["standard-login"])
            
            ex.fulfill()
        }
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
   
    
}
