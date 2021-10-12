//
//  FeatureFlags.swift
//  Landmarks
//
//  Created by Matthew Jannace on 11/11/20.
//
import Firebase

protocol FeatureFlagging {
    func valueForFeature(key:FeatureFlagKeys) -> String?
    func valueForFeature(key:FeatureFlagKeys) -> Int?
    func valueForFeature(key:FeatureFlagKeys) -> Double?
    func valueForFeature(key:FeatureFlagKeys) -> Data?
    func isEnabled(key:FeatureFlagKeys) -> Bool
    func valueforFeature<T>(key:FeatureFlagKeys,type:T.Type) -> T?
    func refresh(refreshBlock: (() -> Void)?)
    
    func initalize(userKey:String) -> Void

}

//protocol SplitFeatureFlag {
//    var defaultAttributes: [String:Any] { get set }
//    func initalize(userKey:String, _ readyCallBack:(()->Void)?) -> Void
//    func deInitialize(_ readyCallBack:(()->Void)?) -> Void
//    func track(trafficType: String, eventType: String, value: Double, properties: [String: Any]?) -> Bool
//}

enum FeatureFlagKeys: String {
    case ShowLandmarkImage = "new_feature"
}

enum BuildType: String {
    case PreProd = "pre-prod"
    case Beta = "beta"
    case Alpha = "alpha"
    case Prod = "prod"
}


class FeatureFlag {
    static let sharedInstance: FeatureFlagging = FireBaseRemoteConfig()
    static let defaultValue = [FeatureFlagKeys.ShowLandmarkImage.rawValue: false as NSObject]
}

class FireBaseRemoteConfig: FeatureFlagging {

    let remoteConfig: RemoteConfig

    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(FeatureFlag.defaultValue)
        self.refresh(refreshBlock: {})
    }

    func initalize(userKey:String) {
        FirebaseAnalytics.Analytics.setUserID(userKey)
        FirebaseAnalytics.Analytics.setUserProperty(BuildType.Beta.rawValue, forName: "buildType")
    }
    
    
    func refresh (refreshBlock: (() -> Void)?) {
        remoteConfig.fetch() { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.remoteConfig.activate() { (changed, error) in
                if let block = refreshBlock {
                    block()
                }
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
        }
    }

    func valueForFeature(key:FeatureFlagKeys) -> String? {
        return nil
    }

    func valueForFeature(key:FeatureFlagKeys) -> Int? {
        return nil
    }

    func valueForFeature(key:FeatureFlagKeys) -> Double? {
        return nil
    }

    func valueForFeature(key:FeatureFlagKeys) -> Data? {
        return nil
    }

    func isEnabled(key:FeatureFlagKeys) -> Bool {
        return remoteConfig.configValue(forKey: key.rawValue).boolValue
    }

    func valueforFeature<T>(key:FeatureFlagKeys,type:T.Type) -> T? {
        return nil
    }
    
    
}
