#
# Be sure to run `pod lib lint FZCarousel.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FZCarousel"
  s.version          = "0.1.0"
  s.summary          = "FZCarouselCollectionViewDelegate provides a straightforward, lightweight interface for producing an \"infinitely\" scrolling carousel."
  s.homepage         = "https://github.com/fuzz-productions/FZCarousel"
  s.license          = 'MPL 2.0'
  s.author           = { "Noah Blake" => "noah@fuzzproductions.com" }
  s.source           = { :git => "https://github.com/fuzz-productions/FZCarousel.git", :tag => '0.1.0' }
  s.social_media_url = 'https://twitter.com/fuzzpro'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'FZCarousel'
  s.resource_bundles = {
    'FZCarousel' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
