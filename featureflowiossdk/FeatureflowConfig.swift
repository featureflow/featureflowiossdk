//
//  FeatureflowConfig.swift
//  Featureflow
//
//  Created by Max Mattini on 21/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation


public class FeatureflowConfig {
    
    // NOTE: that https://app.featureflow.io/api/sdk/v1/features-control does not work
    public static let DEFAULT_BASE_URI                    = "https://app.featureflow.io"
    public static let DEFAULT_STREAM_BASE_URI             = "https://rtm.featureflow.io"
    public static let FEATURE_CONTROL_REST_PATH           = "/api/sdk/v1/features"
    public static let REGISTER_REST_PATH                  = "/api/sdk/v1/register"
    public static let EVENTS_REST_PATH                    = "/api/sdk/v1/events"
    //
    private static let DEFAULT_CONTROL_STREAM_PATH = "/api/sdk/v1/features"
    private static let DEFAULT_CONNECT_TIMEOUT        = 30000
    private static let DEFAULT_SOCKET_TIMEOUT         = 20000
    //
    private(set) var offline = false
    private(set) var dataPath:String?
    private(set) var proxyHost:String?
    private(set) var proxyScheme:String?
    private(set) var proxyPort = -1
    private(set) var connectTimeout = DEFAULT_CONNECT_TIMEOUT
    private(set) var socketTimeout = DEFAULT_SOCKET_TIMEOUT
    private(set) var baseUri = DEFAULT_BASE_URI
    private(set) var streamBaseUri = DEFAULT_STREAM_BASE_URI
    private(set) var controlStreamPath = DEFAULT_CONTROL_STREAM_PATH
    private(set) var waitForStartup:Int64 = 10000
    
    init(offline:Bool , dataPath:String?, proxyHost:String? , proxyScheme:String? , proxyPort:Int , connectTimeout:Int ,  socketTimeout:Int,  baseURI:String?,  streamBaseUri:String?,  waitForStartup:Int64) {
        self.offline = offline
        self.dataPath = dataPath
        self.proxyHost = proxyHost
        self.proxyScheme = proxyScheme
        self.proxyPort = proxyPort
        self.connectTimeout = connectTimeout
        self.socketTimeout = socketTimeout
        if let baseURI = baseURI {
            self.baseUri = baseURI
        } else {
            self.baseUri = FeatureflowConfig.DEFAULT_BASE_URI
        }
        
        if let streamBaseUri = streamBaseUri {
            self.streamBaseUri = streamBaseUri
        } else {
            self.streamBaseUri = FeatureflowConfig.DEFAULT_STREAM_BASE_URI
        }
        self.waitForStartup = waitForStartup;
    }
    
    public static func builder() -> Builder {
        return  Builder()
    }
    
    // TODO: pass timeout, proxy to networking code
    public class Builder {
        private var offline = false
        private var proxyHost:String?
        private var proxyScheme:String?
        private var proxyPort = -1
        private var connectTimeout = DEFAULT_CONNECT_TIMEOUT
        private var socketTimeout = DEFAULT_SOCKET_TIMEOUT
        private var baseURI = DEFAULT_BASE_URI
        private var streamBaseUri = DEFAULT_STREAM_BASE_URI
        private var waitForStartup:Int64 = 10000
        private var dataPath:String?
        
        public func  withOffline(offline:Bool ) -> Builder {
            self.offline = offline
            return self
        }
        
        public func  withDataFromPath(dataPath:String) -> Builder {
            self.dataPath = dataPath
            return self
        }

        public func  withProxyHost(proxyHost:String ) -> Builder{
            self.proxyHost = proxyHost
            return self
        }
        
        public func  withProxyScheme(proxyScheme:String )-> Builder {
            self.proxyScheme = proxyScheme
            return self
        }
        
        public func  withProxyPort(proxyPort: Int) -> Builder{
            self.proxyPort = proxyPort
            return self
        }
        
        public func withConnectTimeout(connectTimeout:Int) -> Builder{
            self.connectTimeout = connectTimeout
            return self
        }
        
        public func  withSocketTimeout(socketTimeout: Int) -> Builder{
            self.socketTimeout = socketTimeout
            return self
        }
        
        public func  withBaseUri(baseUri:String) -> Builder{
            if baseUri.hasSuffix("/") {
                
                let index = baseUri.index(baseUri.endIndex, offsetBy: -1)
                self.baseURI = baseUri.substring(to: index)
            } else {
                self.baseURI = baseUri
            }
            return self
        }
        
        public func  withStreamBaseUri(streamBaseUri:String) -> Builder{
            self.streamBaseUri = streamBaseUri
            return self
        }
        
        public func  withWaitForStartup(waitTimeMilliseconds:Int64)-> Builder{
            self.waitForStartup = waitTimeMilliseconds
            return self
        }
        
        public func  build() -> FeatureflowConfig{
            return  FeatureflowConfig(offline: offline, dataPath:dataPath, proxyHost: proxyHost, proxyScheme: proxyScheme, proxyPort: proxyPort,
                                      connectTimeout: connectTimeout, socketTimeout: socketTimeout,
                                      baseURI: baseURI, streamBaseUri: streamBaseUri, waitForStartup: waitForStartup)
        }
    }

}
