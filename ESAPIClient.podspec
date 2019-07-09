Pod::Spec.new do |s|
  s.name        = 'ESAPIClient'
  s.version     = '1.3.0'
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.summary     = 'ESAPIClient is an API client library built on top of AFNetworking and AFNetworkingExtension.'
  s.homepage    = 'https://github.com/ElfSundae/ESAPIClient'
  s.authors     = { 'Elf Sundae' => 'https://0x123.com' }
  s.source      = { :git => 'https://github.com/ElfSundae/ESAPIClient.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'ESAPIClient/**/*.{h,m}'
  s.dependency 'AFNetworkingExtension', '~> 1.2'
end
