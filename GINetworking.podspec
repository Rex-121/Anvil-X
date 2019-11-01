#
# Be sure to run `pod lib lint GINetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GINetworking'
  s.version          = '0.2.0'
  s.summary          = 'A short description of GINetworking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Rex/GINetworking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rex' => 'rex_wzc@163.com' }
  s.source           = { :git => 'git@114.242.31.175:wangzhichen/iOS_GINetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  
  
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|
      
      core.source_files = 'GINetworking/Core/**/*'
      
      end
  # s.resource_bundles = {
  #   'GINetworking' => ['GINetworking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency 'Moya/ReactiveSwift', '14.0.0-alpha.1'
  s.dependency 'XKit'
  
end
