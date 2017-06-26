//
//  OperatorTests.swift
//  Featureflow
//
//  Created by Max Mattini on 21/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import XCTest

@testable import featureflowiossdk
class OperatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOperator() {
        
        let d1:Double = 1
        let d2:Double = 0.999
        let d3:Double = 3
        
        let s1 = "s1"
        let s2 = "s2"
        let s3 = "s3"
        
        // .contains
        XCTAssertTrue(Operator.contains.evaluate(contextValue:"oliver", targetValues:["liver"]),"Operator.contains")
        XCTAssertTrue(Operator.contains.evaluate(contextValue:"oliver", targetValues:["live"]),"Operator.contains")
        
        // .endsWith
        XCTAssertTrue(Operator.endsWith.evaluate(contextValue:"oliver", targetValues:["liver"]),"Operator.endsWith")
        
        // .startsWith
        XCTAssertTrue(Operator.startsWith.evaluate(contextValue:"oliver", targetValues:["oli"]),"Operator.startsWith")
        
        // .equals
        XCTAssertTrue(Operator.equals.evaluate(contextValue:"oliver", targetValues:["oliver"]),"Operator.equals")
        
        // .greaterThan, .greaterThanOrEqual
        XCTAssertTrue(Operator.greaterThan.evaluate(contextValue: d1, targetValues: [d2]),"Operator.greaterThan")
        XCTAssertTrue(Operator.greaterThanOrEqual.evaluate(contextValue: d1, targetValues: [d2]),"Operator.greaterThanOrEqual")
        XCTAssertTrue(Operator.greaterThanOrEqual.evaluate(contextValue: d1, targetValues: [d1]),"Operator.")
        
        // .lessThan, lessThanOrEquals
        XCTAssertTrue(Operator.lessThan.evaluate(contextValue: d2, targetValues: [d1]),"Operator.")
        XCTAssertTrue(Operator.lessThanOrEqual.evaluate(contextValue: d2, targetValues: [d1]),"Operator.")
        XCTAssertTrue(Operator.lessThanOrEqual.evaluate(contextValue: d2, targetValues: [d2]),"Operator.")
        XCTAssertTrue(Operator.lessThanOrEqual.evaluate(contextValue: d1, targetValues: [d1]),"Operator.")
        
        // .in
        XCTAssertTrue(Operator.inOperator.evaluate(contextValue: d1, targetValues: [d1, d2]),"Operator.inOperator number")
        XCTAssertTrue(Operator.inOperator.evaluate(contextValue: d2, targetValues: [d1, d2]),"Operator.inOperator number")
        XCTAssertFalse(Operator.inOperator.evaluate(contextValue: d2, targetValues: []),"Operator.inOperator number")
        XCTAssertTrue(Operator.inOperator.evaluate(contextValue: s1, targetValues: [s1, s2]),"Operator.inOperator string")
        XCTAssertTrue(Operator.inOperator.evaluate(contextValue: s2, targetValues: [s1, s2]),"Operator.inOperator string")
        XCTAssertFalse(Operator.inOperator.evaluate(contextValue: s2, targetValues: []),"Operator.inOperator string")
        XCTAssertFalse(Operator.inOperator.evaluate(contextValue: d1, targetValues:nil),"Operator.inOperator number")
        XCTAssertFalse(Operator.inOperator.evaluate(contextValue: s1, targetValues:nil),"Operator.inOperator string")

        // .notIn
        XCTAssertTrue(Operator.notIn.evaluate(contextValue: d3, targetValues: nil),"Operator.notIn number")
        XCTAssertTrue(Operator.notIn.evaluate(contextValue: d3, targetValues: [d1, d2]),"Operator.notIn number")
        XCTAssertTrue(Operator.notIn.evaluate(contextValue: d3, targetValues: []),"Operator.inOperator number")
        XCTAssertTrue(Operator.notIn.evaluate(contextValue: s3, targetValues: nil),"Operator.notIn string")
        XCTAssertTrue(Operator.notIn.evaluate(contextValue: s3, targetValues: [s1, s2]),"Operator.notIn string")
        XCTAssertTrue(Operator.notIn.evaluate(contextValue: s3, targetValues: []),"Operator.inOperator string")
        
       //.matches
        XCTAssertTrue(Operator.matches.evaluate(contextValue:"oliver@featureflow.io", targetValues:[ "^(oliver).*$"]),"Operator.matches")
        XCTAssertFalse(Operator.matches.evaluate(contextValue:"oliver@featureflow.io", targetValues:[ "^(max).*$"]),"Operator.matches")
    }
    
    func testDate() {
        XCTAssertTrue(Operator.after.evaluate(contextValue:  "2016-11-20T20:36:19Z", targetValues: ["2016-11-20T20:36:18Z"]),"Operator.after")
        XCTAssertTrue(Operator.before.evaluate(contextValue: "2016-11-20T20:36:17Z", targetValues: ["2016-11-20T20:36:18Z"]),"Operator.before")
    }
}
