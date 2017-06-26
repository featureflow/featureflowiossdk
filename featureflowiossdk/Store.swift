//
//  Store.swift
//  Featureflow
//
//  Created by Max Mattini on 28/05/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//


import UIKit
import Alamofire


final  class Store {
    
    // Can't init singleton from outside
    private init() {}
    
    // MARK: Shared Instance
    static  let sharedInstance = Store()
    
    // MARK: Local Variable
    var featureControls:[String:FeatureControl] = [:]
    var apiKey:String = ""
    var baseUri = ""
    
    
    private func buildError(description:String, code:Int ) -> NSError{
       
        debugPrint(description)
        let error = NSError(domain: "app.featureflow.io", code: (10000 + code), userInfo: ["description":description])
        return error
    }
    
    // MARK: Public api
    func fetchFeatures(completion: @escaping ([String:FeatureControl], NSError?) -> Void)
    {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(apiKey)"]
        
        //[[]]let headers: HTTPHeaders = ["Authorization": "Bearer \(apiKey)", "If-None-Match":"asdh123789"]
        let url = baseUri + FeatureflowConfig.FEATURE_CONTROL_REST_PATH
        
        Alamofire.request(url, headers: headers)/*.validate()*/.responseJSON { response in
            
            let debug = true
            if debug {
                if let _request = response.request {
                    print("HTTP Original request: \(_request)\n\n")
                    
                    if let _requestHeaders = _request.allHTTPHeaderFields {
                        
                    print("HTTP request headers: \(_requestHeaders)\n\n")
                        
                    }
                }
                
                /*
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }*/
                if let _response = response.response {
                    print("HTTP response: \(_response)\n\n")
                    let _headers = _response.allHeaderFields
                    print("HTTP response headers: \(_headers)\n\n")
                }
                if let _responseData = response.data, let _dataAsString = NSString(data: _responseData, encoding: String.Encoding.utf8.rawValue) {
                    print("Server data: \(_dataAsString)\n")
                }
                print("Result of response serialization:\(response.result)\n")
            }
            
            guard response.result.isSuccess else {
               
                debugPrint("Error while fetching features: \(response.result.error)")
                
                completion([String:FeatureControl](), response.result.error as NSError?)
                return
            }
            guard let responseJSON = response.result.value as? [String: Any] else {
                let error = self.buildError(description:"Malformed data received", code:1)
                completion([String:FeatureControl](), error)
                return
            }
            
            if let errorDesc =  self.extractErrorDescription(json: response.result.value as? [String: Any]) {
                let error = self.buildError(description:errorDesc, code:2)
                completion([String:FeatureControl](), error)
            } else {
                self.featureControls.removeAll()
                self.featureControls = self.buildFeatureControls(json: responseJSON, debug:debug)
                completion(self.featureControls, nil)
            }
        }
    }
    
    func readFeaturesFromFile(path: String?, completion: @escaping ([String:FeatureControl], NSError?) -> Void){
        guard let path = path else {
            let error = buildError(description: "Data Path is empty", code: 3)
            completion([String:FeatureControl](), error)
            return
        }
        do {
            let data = NSData(contentsOfFile: path)
            
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data as! Data, options: [])
            guard let jsonDictionary = jsonObject as? [String: Any] else {
                let error = buildError(description: "JSon data format error", code: 4)
                completion([String:FeatureControl](), error)
                return
            }
            
            let printData = true
            if printData, let datastring = NSString(data: data as! Data, encoding: String.Encoding.utf8.rawValue) {
                print(datastring)
            }
            
            self.featureControls.removeAll()
            self.featureControls = self.buildFeatureControls(json: jsonDictionary, debug:printData)
            completion(self.featureControls, nil)
            
        } catch {
            let error = buildError(description: "File contents could not be loaded", code: 4)
            completion([String:FeatureControl](), error)
        }
    }
    
    private func extractErrorDescription(json: [String: Any]?) -> String?
    {
        guard let json = json else {
            return nil
        }
        if let description = json["description"] as? String {
            return description
        }
    
        return nil
    }

    
    private func buildFeatureControls(json: [String: Any], debug:Bool) -> [String:FeatureControl]
    {
        var featureControls:[String:FeatureControl] = [:]
        for key:String in json.keys {
            if let dict = json[key] as? [String: Any],
                let featureControl = FeatureControl(key:key, dict: dict) {
                featureControls[key] = featureControl
                
                if debug {
                    print("Feature Control[\(key)] ---------------------\n\(featureControl)\nFeature Control[\(key)] ++++++++++++++++\n")
                }
            }
        }
        return featureControls
    }
}

