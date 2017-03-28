# Uncomment this line to define a global platform for your project
# Uncomment this line if you're using Swift
# use_frameworks!

target 'bahisadam' do
	platform :ios, '8.2'
	use_frameworks!
	pod 'MBProgressHUD', '~> 0.8'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'AFNetworking', '~> 3.1'
	pod 'Socket.IO-Client-Swift', '~> 8.2'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'Firebase/RemoteConfig'
    pod 'KDCircularProgress'
end

target 'BahisadamLive' do
	platform :ios, '8.2'
	use_frameworks!
	pod 'AFNetworking', '~> 3.1'
end

target 'livewidget' do
	platform :ios, '8.2'
	use_frameworks!
	pod 'AFNetworking', '~> 3.1'
end

target 'WKBahisadamLive' do
	platform :watchos, '3.0'
	use_frameworks!
	pod 'AFNetworking', '~> 3.1'
end

target 'SkorAdamOnTv' do
	platform :tvos, '9.0'
	use_frameworks!
	pod 'AFNetworking', '~> 3.1'
end

target 'TVBahisadamLive' do
	platform :tvos, '9.0'
	use_frameworks!
	pod 'AFNetworking', '~> 3.1'
end

target 'BahisadamWatchExtension' do
	platform :watchos, '3.0'
	use_frameworks!
	pod 'AFNetworking', '~> 3.1'
end

target 'bahisadamUITests' do

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
		end
	end
end


