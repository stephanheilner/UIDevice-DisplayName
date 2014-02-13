Pod::Spec.new do |s|
  s.name         = "UIDevice-DisplayName"
  s.version      = "1.0"
  s.summary      = "Returns a friendly name for any iOS device."
  s.homepage     = "https://github.com/stephanheilner/UIDevice-DisplayName"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Stephan Heilner" => "stephanheilner@gmail.com" }
  s.source       = { :git => "https://github.com/stephanheilner/UIDevice-DisplayName.git", :tag => "#{s.version}" }
  s.source_files  = 'UIDevice+DisplayName.{h,m}'
  s.platform     = :ios
end