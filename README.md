# featureflowiossdk
Featureflow iOS SDK

Featureflow is a software delivery product.

We believe that software delivery should be enjoyable :)
Featureflow keeps the business in control and makes champions of developers.

- Feature Management
- Rollout Management
- Feature Targeting
- Variant Testing

see https://www.featureflow.io/ for more details

## Requirements
- XCode 8.3 and Higher
- Swift 3
- iOS 9.0+

## Installation
### CocoaPods
CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```
See https://cocoapods.org for more info on how to install and use CocoaPod

To integrate featureflowiossdk into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'featureflowiossdk'
end
```

## Example
```
private func evaluate() {
        let apiKey = "<PUT-HERE-YOUR_API-KEY>"
        
        // 1- Create a configuration
        let config = FeatureflowConfig.builder().withBaseUri(baseUri: "https://app.featureflow.io").build()
        
        
        // 2 - Define the target context
        let context = FeatureflowContext.keyedContext(key: "uniqueuserkey1")
            .withValue(key:"tier", value: "silver")
            .withValue(key:"age", value: 32)
            .withValue(key:"signup_date", date:Date())
            .withValue(key:"user_role", value: "standard_user")
            .withValue(key:"name", value: "John Smith")
            .withValue(key:"email", value: "oliver@featureflow.io")
            .build()
        
        // 3 - List the features of interest to you
        let features = [  
                          Feature(key:"facebook-login", variants:nil, failoverVariant: "red"),
                          Feature(key:"standard-login", variants:nil, failoverVariant:Variant.off)]
        
        // 4 - Create the Featureflow client
        let featureFlowClient =  FeatureflowClientBuilder(apiKey:apiKey)
            .withFeatures(features:features)
            .withConfig(config: config).build()
        
       // 5 - Poll the features from the server
        featureFlowClient.retrieveFeatureControl(){ (featureControls, error) in
            print("\(featureControls.keys.count) feature control read from the server")
    
            // 6 - Check if Facebook login feature is on
            let facebookLogonFeatureisOn = featureFlowClient.evaluate(featureKey: "facebook-login", featureflowContext: context).isOn()
            print("Facebook Login integration: \(facebookLogonFeatureisOn)")
        }
    }

