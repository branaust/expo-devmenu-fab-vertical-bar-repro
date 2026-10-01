Pod::Spec.new do |s|
  s.name           = 'VerticalBarProbe'
  s.version        = '1.0.0'
  s.summary        = 'Presents a view controller that opts out of the iPhone Duo vertical bar'
  s.author         = ''
  s.homepage       = 'https://github.com/expo/expo'
  s.license        = { type: 'MIT' }
  s.platform       = :ios, '16.4'
  s.source         = { git: '' }
  s.static_framework = true
  s.dependency 'ExpoModulesCore'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.source_files = '**/*.swift'
end
