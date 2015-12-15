

Pod::Spec.new do |s|



  s.name         = 'MWBLoopView'
  s.version      = '1.0.4'
  s.summary      = '这是一个可以循环滚动的view，可用于banner轮播'
  s.description  = <<-DESC
                   A longer description of WXInputView in Markdown format.

                   * 用collectionview 做的
                   * 可以控制是否自动轮播，是否显示pagecontrol和 label
                   * 可以定制默认图，以及没有数据时是否显示该view
                   * 具体使用参看属性和demo
                   DESC

  s.homepage     = 'https://github.com/wenboma/MWBLoopView.git'

  s.license      = 'MIT'

  s.author             = { '马文铂' => 'ma_wenbo@126.com' }

#  s.compiler_flags = '-fmodules'
  s.platform     = :ios, '7.0'


  s.source       = { :git => 'https://github.com/wenboma/MWBLoopView.git', :tag => '1.0.4' }

  s.source_files  = "LoopView", "LoopView/*"
  s.dependency 'SDWebImage'


  s.frameworks = 'UIKit', 'Foundation'

  s.compiler_flags = '-fmodules'
  s.requires_arc = true
  # cs.dependency 'ReactiveCocoa/RACEXTScope'

#  s.subspec 'ReactiveCocoa' do |cs|
#    cs.dependency 'ReactiveCocoa/ReactiveCocoa'
#    cs.dependency 'ReactiveCocoa/RACEXTScope'
#  end

end
