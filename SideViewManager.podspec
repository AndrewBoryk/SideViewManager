#
# Be sure to run `pod lib lint SideViewManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SideViewManager'
  s.version          = '0.5.0'
  s.summary          = 'A manager for controlling the presentation of a view moving on and off screen.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This pod provides a manager class titled `SideViewManager` which handles the presentation of moving a view on and off screen. The frames for on and off screen are customizable, as well as there are gestures for swiping the view on and off screen as well as tap away to dismiss.
                       DESC

  s.homepage         = 'https://github.com/AndrewBoryk/SideViewManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AndrewBoryk' => 'andrewcboryk@gmail.com' }
  s.source           = { :git => 'https://github.com/AndrewBoryk/SideViewManager.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/trepislife'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SideViewManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SideViewManager' => ['SideViewManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
