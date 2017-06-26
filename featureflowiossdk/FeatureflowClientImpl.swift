//
//  FeatureflowClientImpl.swift
//  featureflowsdk
//
//  Created by Max Mattini on 25/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation

class FeatureflowClientImpl: FeatureflowClient{
    
    private var featuresDict:[String:Feature] = [:]
    private let config:FeatureflowConfig
    
    init(apiKey: String, features:[Feature], config: FeatureflowConfig)
    {
        Store.sharedInstance.apiKey = apiKey
        Store.sharedInstance.baseUri = config.baseUri
        
        self.config = config
        
        //Actively defining registrations helps alert if features are available in an environment
        for feature in features {
            featuresDict[feature.key] = feature
        }
    }
    
    public func retrieveFeatureControl(completion: @escaping ([String:FeatureControl], NSError?) -> Void)
    {
        if let dataPath = config.dataPath {
            Store.sharedInstance.readFeaturesFromFile(path: dataPath){ (featureControls, error) in
                DispatchQueue.main.async {
                    completion(featureControls, error)
                }
            }
            return
        }
        if !config.baseUri.isEmpty {
            Store.sharedInstance.fetchFeatures(){ (featureControls, error) in
                
                DispatchQueue.main.async {
                    completion(featureControls, error)
                }
            }
            return
        }
    }
    
    public func evaluate(featureKey: String , featureflowContext: FeatureflowContext ) -> Evaluate {
        let e =  Evaluate(featureflowClient:self, featureKey:featureKey, featureflowContext:featureflowContext)
        return e
    }
    
    public func evaluateAll(featureflowContext:FeatureflowContext) -> [String:String] {
        var result:[String:String] = [:]
        
        for featureKey in  Store.sharedInstance.featureControls.keys {
            result[featureKey] =  eval(featureKey: featureKey, featureflowContext: featureflowContext)
        }
        return result;
    }
    
    public func evaluate(featureKey: String ) -> Evaluate {
        //create and empty context
        let featureflowContext = FeatureflowContext.context().build()
        return self.evaluate(featureKey:featureKey, featureflowContext:featureflowContext)
        
    }
    
    func eval(featureKey: String , featureflowContext: FeatureflowContext ) -> String {
        var  failoverVariant:String
        if let feature = featuresDict[featureKey] {
            failoverVariant = feature.failoverVariant
        } else {
            failoverVariant = Variant.off
        }
        guard  let featureControl = Store.sharedInstance.featureControls[featureKey] else {
            print("Unknown Feature \(featureKey), returning failoverVariant value of \(failoverVariant)")
            
            return failoverVariant
        }
        
        addAdditionalContext(featureflowContext: featureflowContext)
        let variant = featureControl.evaluate(context: featureflowContext)
        return variant!
    }
    
    private func addAdditionalContext(featureflowContext: FeatureflowContext ) {
        let hourOfTheDay = Calendar.current.component(.hour, from: Date())
        featureflowContext.values[featureflowContext.FEATUREFLOW_HOUROFDAY] = hourOfTheDay
        featureflowContext.values[featureflowContext.FEATUREFLOW_DATE] = FeatureflowContext.Builder.toIso(date: Date())
    }
}
