Pod::Spec.new do |spec|
  spec.name         = 'UIDevice-DisplayName'
  spec.version      = '1.0'
  spec.summary      = 'Returns a friendly name for any iOS device.'
  spec.homepage     = 'https://github.com/stephanheilner/UIDevice-DisplayName'
  spec.author       = { 'Stephan Heilner' => 'stephanheilner@gmail.com' }
  spec.source       = { :git => 'https://github.com/stephanheilner/UIDevice-DisplayName.git', :tag => "v#{spec.version}" }
  spec.description  = 'UIDevice-DisplayName is a simple category on UIDevice to give you a friendly device name'
  spec.source_files = 'UIDevice-DisplayName/*.{h,m}'
  spec.requires_arc = true
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
end