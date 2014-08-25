Pod::Spec.new do |as|
	as.name         = 'AppSDK'
	as.version      = '0.2.0'
	as.license      = 'MIT'
	as.homepage     = 'https://bitbucket.org/tpthn/appsdk'
	as.authors      = { 'PC Nguyen' => 'tpthn@yahoo.com' }
	as.summary      = 'Collection Of Tools Neccesary To Start An iOS App'
	as.source       = { :git => 'https://tpthn@bitbucket.org/tpthn/appsdk.git',
						:branch => 'master' }
	as.requires_arc = true
	as.ios.deployment_target = '6.0'
  
	as.subspec 'AppLib' do |al|
		al.name         = 'AppLib'
		al.source_files = 'AppLib/*.{h,m}'
		
		al.subspec 'Extension' do |ale|
			ale.name         = 'Extension'
			ale.source_files = 'AppLib/Extension/**/*.{h,m}'
		end
		
		al.subspec 'ValueTransformer' do |alvt|
			alvt.name         = 'ValueTransformer'
			alvt.source_files = 'AppLib/Value Transformer/**/*.{h,m}'
		end
		
		al.subspec 'Scheduler' do |als|
			als.name         = 'Scheduler'
			als.source_files = 'AppLib/Scheduler/**/*.{h,m}'
		end
	end
	
	as.subspec 'DataLib' do |dl|
		dl.name         = 'DataLib'
		dl.source_files = 'DataLib/*.{h,m}'
		
		dl.subspec 'Extension' do |dle|
			dle.name         = 'Extension'
			dle.source_files = 'DataLib/Extension/**/*.{h,m}'
		end
		
		dl.subspec 'DiskPersistent' do |dldp|
			dldp.name         = 'DiskPersistent'
			dldp.source_files = 'DataLib/Disk Persistent/**/*.{h,m}'
		end
		
		dl.subspec 'AppPersistent' do |dlap|
			dlap.name         = 'AppPersistent'
			dlap.source_files = 'DataLib/App Persistent/**/*.{h,m}'
		end
		
		dl.subspec 'CoreData' do |dlcd|
			dlcd.name         = 'CoreData'
			dlcd.source_files = 'DataLib/CoreData/**/*.{h,m}'
			dlcd.frameworks   = 'CoreData'
		end
	end
	
	as.subspec 'UILib' do |ul|
		ul.dependency	'AppSDK/AppLib/Extension'

		ul.name         = 'UILib'
		ul.source_files = 'UILib/*.{h,m}'
		ul.frameworks   = 'UIKit', 'CoreGraphics', 'QuartzCore'
		
		ul.subspec 'Extension' do |ule|
			ule.name         = 'Extension'
			ule.source_files = 'UILib/Extension/**/*.{h,m}'
		end
		
		ul.subspec 'AutoLayout' do |ulal|
			ulal.name			= 'AutoLayout'
			ulal.source_files	= 'UILib/Autolayout/**/*.{h,m}'
		end

		ul.subspec 'DataBinding' do |uldb|
			uldb.dependency		'AppSDK/AppLib/ValueTransformer'

			uldb.name         = 'DataBinding'
			uldb.source_files = 'UILib/Data Binding/**/*.{h,m}'
		end
		
		ul.subspec 'TagTable' do |ultt|
			ultt.name         = 'TagTable'
			ultt.source_files = 'UILib/Tag Table/**/*.{h,m}'
		end
	end
end