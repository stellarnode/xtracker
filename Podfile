# Uncomment this line to define a global platform for your project
#platform :ios, '9.0'

def shared_pods
    pod 'Alamofire', '~> 3.2.0'
    pod 'SwiftyJSON', '~> 2.3.0’
    pod 'SwiftyUserDefaults', '~> 2.2.1’
end

target 'TcehProject' do
    platform :ios, '9.0'
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    shared_pods
    pod 'SDWebImage', '~>3.8'
    pod 'Money'
    pod 'PromiseKit', '~> 3.5'
    pod 'Charts', '~> 2.2.5’
    pod 'RandomColorSwift', '~> 0.1.0'
    #  pod 'Realm'
    #  pod 'RealmSwift'
end

target 'TcehWidget' do
    platform :ios, '9.0'
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    shared_pods
end

target 'TcehWatch Extension' do
    platform :watchos, '2.0'
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    shared_pods
end