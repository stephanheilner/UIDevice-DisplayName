Pod::Spec.new do |s|
  s.name         = 'UIDevice-DisplayName'
  s.version      = '4.3.1'
  s.summary      = 'Returns a friendly name for any iOS device.'
  s.author       = 'Stephan Heilner'
  s.homepage     = 'https://github.com/stephanheilner/UIDevice-DisplayName'
  s.license      = 'MIT'

  s.description  = <<-DESC
                   UIDevice-DisplayName is a category on UIDevice that returns a displayable name of the device, 
                   based on the model of device. 
                   DESC

  s.source       = { :git => 'https://github.com/stephanheilner/UIDevice-DisplayName.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'
  s.source_files  = 'Sources/UIDevice-DisplayName/UIDevice+DisplayName.{swift}'
  s.resources    = 'Resources/UIDevice-DisplayName/*.json'
  s.requires_arc = true
  s.swift_version = '5.0'
end
