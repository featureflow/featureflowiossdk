Pod::Spec.new do |s|

s.name         = "featureflowiossdk"
s.version      = "0.0.2"
s.summary      = "Featureflow SDK for iOS."
s.description  = <<-DESC
Software delivery should be enjoyable :)
Featureflow keeps the business in control and makes champions of developers.
DESC

s.homepage     = "https://github.com/featureflow/featureflowiossdk.git"
#s.license = "MIT"
 s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author             = { "mmattini" => "maxmattini@gmail.com" }
s.platform     = :ios
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/featureflow/featureflowiossdk.git", :tag => "#{s.version}" }
s.source_files  = "featureflowiossdk/**/*.{swift}"
s.framework  = "UIKit"
s.requires_arc = true
s.dependency 'Alamofire', '~> 4.4'
s.dependency 'CryptoSwift'

end
