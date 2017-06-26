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
