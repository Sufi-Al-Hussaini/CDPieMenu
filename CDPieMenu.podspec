Pod::Spec.new do |s|
    s.name     = 'CDPieMenu'
    s.version  = '0.1'
    s.license  = 'MIT License'
    s.summary  = 'Fully and easily customizable rotary wheel control also called pie menu for iPhone and iPad.'
    s.homepage = 'https://github.com/wczekalski/CDPieMenu'
    s.author   = { 'W. Czekalski'    => 'me@wczekalski.com' }

    s.source   = { :git => 'https://github.com/Sufi-Al-Hussaini/CDPieMenu', :tag => s.version }
    s.source_files = 'Wheel'

    s.description = 'Fully and easily customizable rotary wheel control also called pie menu for iPhone and iPad.'
    'Very similar to the control in Convertbot. As the only one in the internet it rotates with inertia/mementum.'
    'Drawn using CoreGraphics without any images.'

    s.platform = :ios
    s.frameworks = 'AudioToolbox', 'QuartzCore'
    s.requires_arc = true
end