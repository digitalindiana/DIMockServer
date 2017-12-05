#
# Be sure to run `pod lib lint TMOMockServer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DIMockServer'
  s.version          = '0.1.0'
  s.summary          = 'Small framework that helps mock server during UI Tests and development'

  s.homepage		     = "https://github.com/digitalindiana/DIMockServer"
  s.license          = { :type => 'Copyright', :file => 'LICENSE' }
  s.author           = { 'Piotr Adamczak' => 'piotr.adamczak@digitalindiana.pl' }
  s.source           = { :http => 'https://github.com/digitalindiana/DIMockServer', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files 	 = 'DIMockServer/Classes/**/*'
  s.resources 		 = 'DIMockServer/Resources/**/*.*'
  s.dependency 		 'Swifter'
  s.dependency 		 'GRMustache.swift'
  s.dependency		 'QorumLogs'
end
