
Pod::Spec.new do |spec|


  spec.name         = "DVMediaPicker"
  spec.version      = "0.0.1"
  spec.summary      = "the mediaPicker can picker video and photo"

  TODO:the mediaPicker can picker video and photo
                   DESC

  spec.homepage     = "https://github.com/Leo-David/DVMediaPicker"
 
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "" => "337581468@.com" }
 
  spec.platform     = :ios, "8.0"

  spec.source       = { :git => "https://github.com/Leo-David/DVMediaPicker.git", :tag => "#{spec.version}" }


  spec.source_files = 'DVMediaPicker/**/*.{swift,h,m}'

  spec.resources     = 'DVMediaPicker/**/*.{png,bundle}'
    



end
