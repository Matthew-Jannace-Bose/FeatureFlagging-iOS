//
//  FeatureFlags.swift
//  Landmarks
//
//  Created by Matthew Jannace on 11/11/20.
//
//import Firebase
//
import Split
import os

protocol FeatureFlagging {
    var defaultAttributes: [String:Any] { get set }
    func initalize(userKey:String, _ readyCallBack:(()->Void)?) -> Void
    func deInitialize(_ readyCallBack:(()->Void)?) -> Void
    func track(trafficType: String, eventType: String, value: Double, properties: [String: Any]?) -> Bool

    func valueForFeature(key:FeatureFlagKeys) -> String?
    func valueForFeature(key:FeatureFlagKeys) -> Int?
    func valueForFeature(key:FeatureFlagKeys) -> Double?
    func valueForFeature(key:FeatureFlagKeys) -> Data?
    func isEnabled(key:FeatureFlagKeys) -> Bool
    func valueforFeature<T>(key:FeatureFlagKeys,type:T.Type) -> T?
    func refresh(refreshBlock: (() -> Void)?)
}

enum FeatureFlagKeys: String {
    case ShowLandmarkImage = "show_landmark_image"
}

public class FeatureFlag {
    static let sharedInstance: FeatureFlagging = SplitFeatureFlags()
    static let defaultValue = [FeatureFlagKeys.ShowLandmarkImage.rawValue: false as NSObject]
}

class SplitFeatureFlags: FeatureFlagging {

    /// Logger for this class.
    private let logger: Logger
    
    var client: SplitClient!
    
    var clientReady = false
    let useLocalHost = false
    
    // Your Split API-KEY
    let apiKey: String = "k2onjk13lifvif7f58bpfm1crmrh7m5ehlo2"

    var defaultAttributes:[String:Any] = [:]

    init(){
        self.logger = Logger(subsystem: "\(Self.self)", category: "Feature Flagging")
    }
    
    func initalize(userKey:String, _ readyCallBack:(()->Void)? = nil){

        if(useLocalHost) {
            //User Key
            let key: Key = Key(matchingKey: userKey)
            //Split Configuration
            let config = SplitClientConfig()
            config.isDebugModeEnabled = true
            
            
            //Split Factory
            let builder = DefaultSplitFactoryBuilder()
            
            
            if (useLocalHost) {
                config.splitFile = "splitConfig.yaml"
                _ = builder.setApiKey("localhost")
            } else {
                _ = builder.setApiKey(apiKey)
            }
                    
            let factory = builder.setKey(key).setConfig(config).build()
            
            //Split Client
            client = factory!.client
            
            client.on(event: SplitEvent.sdkReady) { [self] in
                clientReady = true
                logger.debug("Split Client Ready:")
            }
        } else {
            //User Key
            let key: Key = Key(matchingKey: userKey)
            //Split Configuration
            let config = SplitClientConfig()
            config.isDebugModeEnabled = true
            config.isVerboseModeEnabled = true
            
            
            //Split Factory
            let builder = DefaultSplitFactoryBuilder()
            let factory = builder.setApiKey(apiKey).setKey(key).setConfig(config).build()
            
            //Split Client
            client = factory!.client
            
            client.on(event: SplitEvent.sdkReady) { [self] in
                clientReady = true
                logger.debug("Split Client Ready:")
                
                if let calback = readyCallBack{
                    calback()
                }
            }
        }
    }
    
    func deInitialize(_ readyCallBack:(()->Void)? = nil) {
        client.flush()
        client?.destroy() {
            if let calback = readyCallBack {
                calback()
            }
        }
        
//        let semaphore = DispatchSemaphore(value: 0)
//        client?.destroy(completion: {
//            _ = semaphore.signal()
//        })
//        semaphore.wait()
    }
    
    func track(trafficType: String, eventType: String, value: Double, properties: [String: Any]?) -> Bool {
        
        let result = client.track(trafficType: trafficType, eventType: eventType, value: value, properties: properties)
        client.flush()
        return result
        
//        let properties: [String:Any] = ["seenImage": seenImage]
//        let result = client.track(trafficType: "user", eventType: "SHOWN_IMAGE", value: (seenImage ? 1.0:0.0), properties: properties)
//        print("Track Result: \(result)")
//        client.flush()
  }

    func refresh (refreshBlock: (() -> Void)?) {
        
    }

    func valueForFeature(key:FeatureFlagKeys) -> String? {
        return nil
    }

    func valueForFeature(key:FeatureFlagKeys) -> Int?{
        return nil
    }

    func valueForFeature(key:FeatureFlagKeys) -> Double?{
        return nil
    }

    func valueForFeature(key:FeatureFlagKeys) -> Data?{
        return nil
    }

    func isEnabled(key:FeatureFlagKeys) -> Bool{
        
        let treatment = client.getTreatment(key.rawValue,attributes: defaultAttributes )

        switch (treatment){
        case "on":
            return true
        case "off":
            return false
        default:
            logger.debug("Split Client Not Ready: treatment=\(treatment)")
            return false
        }
    }

    func valueforFeature<T>(key:FeatureFlagKeys,type:T.Type) -> T? {
        return nil
    }
}
