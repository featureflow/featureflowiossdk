//
//  FeatureflowClient.swift
//  Featureflow
//
//  Created by Max Mattini on 21/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation


public protocol FeatureflowClient {
    
    func evaluate( featureKey:String,  featureflowContext:FeatureflowContext) -> Evaluate
    func evaluate( featureKey:String) -> Evaluate
    func evaluateAll(featureflowContext:FeatureflowContext) -> [String:String]
    func retrieveFeatureControl(completion: @escaping ([String:FeatureControl], NSError?) -> Void)
}

public class FeatureflowClientBuilder {
    
    private var config: FeatureflowConfig?
    private let apiKey:String
    private var features:[Feature] = []
    
    public init(apiKey:String){
        self.apiKey = apiKey
    }
    
    // TODO:  add callbacks and upstream
    public func withConfig(config:FeatureflowConfig ) -> FeatureflowClientBuilder{
        self.config = config
        return self
    }
    
    public func withFeature(feature:Feature)  -> FeatureflowClientBuilder{
        self.features.append(feature)
        return self
    }
    
    public func withFeatures( features: [Feature])  -> FeatureflowClientBuilder{
        self.features = features
        return self
    }
        
    public func build() -> FeatureflowClient {
    
        if  config == nil {
            config =  FeatureflowConfig.Builder().build()
        }
        return  FeatureflowClientImpl(apiKey:apiKey, features:features, config:config!)
    }
}



public class Evaluate {
    private var evaluateResult:String
    
    init(featureflowClient:FeatureflowClientImpl , featureKey:String, featureflowContext: FeatureflowContext ) {
        evaluateResult = featureflowClient.eval(featureKey:featureKey, featureflowContext:featureflowContext)
    }
    
    public func isOn() -> Bool{
        return _is(variant:Variant.on)
    }
    
    public func isOff() -> Bool {
        return _is(variant:Variant.off)
    }
    
    public func _is(variant:String) -> Bool{
        return variant == evaluateResult
    }
    
    public func value() -> String{
        return evaluateResult
    }
}

