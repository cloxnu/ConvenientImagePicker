#
# Be sure to run `pod lib lint ConvenientImagePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ConvenientImagePicker'
  s.version          = '0.2.1'
  s.summary          = 'A beautiful iOS Image Picker.'
  s.swift_version    = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: This is a beautiful and simple image picker that can be used to select photos of the system album, or your own image collection, alternative multi-select or single-select, and you can define a more beautiful look.
                       DESC

  s.homepage         = 'https://github.com/CLOXnu/ConvenientImagePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CLOX' => 'o18089541818@outlook.com' }
  s.source           = { :git => 'https://github.com/CLOXnu/ConvenientImagePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ConvenientImagePicker/Classes/**/*'
  
  s.resource_bundles = {
    'ConvenientImagePicker' => ['Images/*.{png,xcassets}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
