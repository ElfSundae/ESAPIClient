Pod::Spec.new do |s|
  s.name        = 'ESAPIClient'
  s.version     = '1.5.3'
  s.license     = 'MIT'
  s.summary     = 'ESAPIClient is an API client library built on top of AFNetworking.'
  s.homepage    = 'https://github.com/ElfSundae/ESAPIClient'
  s.social_media_url = 'https://twitter.com/ElfSundae'
  s.authors     = { 'Elf Sundae' => 'https://0x123.com' }
  s.source      = { :git => 'https://github.com/ElfSundae/ESAPIClient.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'

  s.ios.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'com.0x123.ESAPIClient' }
  s.tvos.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'com.0x123.ESAPIClient' }
  s.osx.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'com.0x123.ESAPIClient' }
  s.watchos.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'com.0x123.ESAPIClient-watchOS' }

  s.source_files = 'ESAPIClient/*.{h,m}'

  s.dependency 'AFNetworking/NSURLSession', '>= 3.2.2'
end
