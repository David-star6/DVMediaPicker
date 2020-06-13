
Pod::Spec.new do |spec|


  spec.name         = "DVMediaPicker"
  spec.version      = "0.0.2"
  spec.summary      = "the mediaPicker can picker video and photo"

  spec.homepage     = "https://github.com/Leo-David/DVMediaPicker"
 
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author        = { "" => "337581468@.com" }
 
  spec.platform     = :ios, "8.0"

  spec.source       = { :git => "https://github.com/Leo-David/DVMediaPicker.git", :tag => "#{spec.version}" }


  spec.source_files = 'DVMediaPicker/**/*.{swift,h,m}'

  spec.resources     = 'DVMediaPicker/**/*.{png,bundle}'
    



end
