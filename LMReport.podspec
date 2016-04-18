Pod::Spec.new do |s|
  s.name         = "LMReport"
  s.version      = "0.0.1"
  s.license      = "MIT"
  s.summary      = "多功能报表控件，支持整体样式和单元格样式的设置，支持复合表头、自适应行高、触摸事件响应已经排序，基本满足常见报表功能。"
  s.homepage     = "https://github.com/littleMeaning/LMReport"
  s.author       = { "littleMeaning" => "littleMeaning@yeah.net" }
  s.source       = { :git => "https://github.com/littleMeaning/LMReport.git", :tag => "v0.0.1" }
  s.source_files = 'Classes'
  s.requires_arc = true
  s.platform     = :ios, "7.0"
end