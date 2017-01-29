#
# Be sure to run `pod lib lint Microfutures.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Microfutures'
  s.version          = '0.1.1'
  s.summary          = 'Lightweight implementation of Futures that shares a similar subscription interface with RxSwift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Lightweight implementation of Futures that shares a similar subscription interface with RxSwift.'

  s.homepage         = 'https://github.com/fmo91/Microfutures'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Fernando Ortiz' => 'ortizfernandomartin@gmail.com' }
  s.source           = { :git => 'https://github.com/fmo91/Microfutures.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Microfutures/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Microfutures' => ['Microfutures/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
