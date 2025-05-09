#
# Be sure to run `pod lib lint BreadPartnersSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BreadPartnersSDK'
  s.version          = '0.0.1'
  s.summary          = 'A short description of BreadPartnersSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/SHUBHAM SINGHAL/BreadPartnersSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SHUBHAM SINGHAL' => 'shubham.singhal@breadfinancial.com' }
  s.source           = { :git => 'https://github.com/SHUBHAM SINGHAL/BreadPartnersSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'

  s.source_files = 'BreadPartnersSDK/Classes/**/*'
  
  s.resource_bundles = {
    'BreadPartnersSDKResources' => ['BreadPartnersSDK/Resources/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  # Dependencies
  s.dependency 'SwiftSoup', '~> 2.7.5'
  s.dependency 'RecaptchaEnterprise', '18.6.0'
end
