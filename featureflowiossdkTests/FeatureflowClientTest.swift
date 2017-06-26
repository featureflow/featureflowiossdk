//
//  FeatureflowClientTest.swift
//  Featureflow
//
//  Created by Max Mattini on 22/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import XCTest

@testable import featureflowiossdk
class FeatureflowClientTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFileEvaluate1() {
        evaluate(fromFile:true)
    }
    
    func testNetEvaluate() {
        evaluate(fromFile:false)
    }
    
    private func evaluate(fromFile:Bool) {
        var apiKey = ""
        var timeout = 2
        var configBuilder: FeatureflowConfig.Builder = FeatureflowConfig.builder()
        if fromFile {
            let bundle = Bundle(for: type(of: self))
            guard let path = bundle.path(forResource: "testData", ofType: "json") else {
                XCTFail()
                return
            }
            configBuilder = configBuilder.withDataFromPath(dataPath: path)
        } else {
            timeout = 10
            apiKey = "srv-env-cd07a68be3fa4030ae08cc168f180887"
            configBuilder = configBuilder.withBaseUri(baseUri: "https://app.featureflow.io/")
           
        }
        let config = configBuilder.build()
        
        let context = FeatureflowContext.keyedContext(key: "uniqueuserkey1")
            .withValue(key:"tier", value: "silver")
            .withValue(key:"age", value: 32)
            .withValue(key:"signup_date", date:Date())
            .withValue(key:"user_role", value: "standard_user")
            .withValue(key:"name", value: "John Smith")
            .withValue(key:"email", value: "oliver@featureflow.io")
            .build()
        
        let features = [  Feature(key:"something", variants:nil, failoverVariant: "red"),
                          Feature(key:"summary-dashboard", variants:nil, failoverVariant:Variant.off),
                          Feature(key:"feature1", variants:nil, failoverVariant:Variant.off),
                          Feature(key:"facebook-login", variants:nil, failoverVariant: "red"),
                          Feature(key:"standard-login", variants:nil, failoverVariant:Variant.off),
                          Feature(key:"example-feature", variants:nil, failoverVariant:Variant.off)]
        
        let featureflowClient =  FeatureflowClientBuilder(apiKey:apiKey)
            .withFeatures(features:features)
            .withConfig(config: config).build()
        
        let ex = expectation(description: "expectation")
        featureflowClient.retrieveFeatureControl(){ (featureControls, error) in
            print("\(featureControls.keys.count) feature control read from file")
            ex.fulfill()
            
        }
        waitForExpectations(timeout: TimeInterval(timeout)) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        XCTAssertEqual(true, featureflowClient.evaluate(featureKey: "facebook-login", featureflowContext: context).isOn())
        XCTAssertEqual(true, featureflowClient.evaluate(featureKey: "something", featureflowContext: context).isOff())
    }
    
    
    
     func testWrongKey() {
        let apiKey = "srv-env-cd07a68be3fa4030a99" // bogus key
        let timeout = 10
        let config = FeatureflowConfig.builder().withBaseUri(baseUri: "https://app.featureflow.io/").build()
        
        let featureflowClient =  FeatureflowClientBuilder(apiKey:apiKey)
            .withConfig(config: config).build()
        
        let ex = expectation(description: "expectation")
        featureflowClient.retrieveFeatureControl(){ (featureControls, error) in
            
            XCTAssertNotNil(error, "Should not handle wrong key")
            if let error = error {
                print("Error: \(error.localizedDescription)")
               
                let userInfo = error.userInfo
                let description = userInfo["description"] ?? "?"
                print("Error description: '\(description)'")
                
            }
            ex.fulfill()
            
        }
        waitForExpectations(timeout: TimeInterval(timeout)) { error in
            if let error = error {
                XCTFail("expectation not fullfilled error: \(error)")
            }
        }
    }
}
