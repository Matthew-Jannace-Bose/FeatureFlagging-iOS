//
//  Analytics.swift
//  Landmarks
//
//  Created by Matthew Jannace on 11/12/20.
//

import Segment
import Segment_Firebase

public protocol AnalyticsServicing {
    func getAnonymousId() -> String
    func enable()
    func disable()
    func identify(_ userId: String)
    func reset()
    func resetAndRetainAnonID(async:Bool)
    func track<T: RawRepresentable>(screen: T, properties: [AnalyticsProperty: AnalyticsSerializable]?) where T.RawValue == String
    func track<T: RawRepresentable>(event: T, properties: [AnalyticsProperty: AnalyticsSerializable]?) where T.RawValue == String
    /// Legacy method that accepts a dictionary with any arbitrary String key.
    /// We should prefer using the methods above (using AnalyticsProperty for keys).
    /// This was kept around to accommodate the BoseEvent.general associated value `info`.
    func track(event: String, properties: [String: Any]?, value:String?)
}

public extension AnalyticsServicing {
    func track<T: RawRepresentable>(screen: T) where T.RawValue == String {
        track(screen: screen, properties: nil)
    }
    
    func track<T: RawRepresentable>(event: T) where T.RawValue == String {
        track(event: event, properties: nil)
    }
}

class bAnalytics {
    static let sharedInstance: AnalyticsServicing = Segment()
}

class Segment: AnalyticsServicing {
    
    let segment: Analytics
    let defaultSegmentOptions: [String:Any] = ["context":["protocols":["event_version":1]]]
    //    let defaultSegmentOptions: [String:Any] = [String:Any]()
    var delay:Double = 0.1
    var counter:Int = 0
    
    
    init() {
        // Override point for customization after application launch.
        let configuration = AnalyticsConfiguration(writeKey: "dwVKKO4bsVLK1KZy5UFzpzSliOTIeeMs")
        
        //        configuration.use(SEGFirebaseIntegrationFactory.instance())
        configuration.flushAt = 1
        
        Analytics.setup(with: configuration)
        Analytics.debug(true)
        segment = Analytics.shared()
    }
    
    func getAnonymousId() -> String {
       return segment.getAnonymousId()
    }

    
    public func identify(_ userId: String) {
        segment.identify(userId, traits: nil, options: nil)
    }
    
    public func reset() {
        segment.reset()
    }
    
    public func resetAndRetainAnonID(async:Bool = true) {
        
        let anonID = segment.getAnonymousId()
        print("MJ: Got Segment AnonID = \(anonID)")
        
        print("MJ: Called Segment Reset")
        segment.reset()
        
        print("MJ: Disabling Segment")
        segment.disable()
        
        // Syncronisly calling Identify after reset does not seem to work, need to allow Segement time to reset the Segment integration Middleware
        if (async) {
            counter = 0;
            waitForResetIn(anonID: anonID, afterDelay: delay)
        }
        else {
            let newAnonID = segment.getAnonymousId()
            print("MJ: New Segment AnonID = \(newAnonID)")
            
            let traits = ["anonymousId": anonID]
            
            print("MJ: Enabling Segment")
            segment.enable()
            
            print("MJ: Calling Identify = User:nil, Traits: \(traits), options: \(traits)")
            segment.identify(nil, traits: traits, options: traits)
        }
    }
    
    // Recursive Waiting for reset.
    func waitForResetIn(anonID:String, afterDelay:Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay) {
          
            print("MJ: waitForResetIn: Counter: \(self.counter)")
            
            self.counter+=1
            let currentAnonID = self.segment.getAnonymousId()
            
            if(anonID != currentAnonID) {
                let newAnonID = self.segment.getAnonymousId()
                print("MJ: New Segment AnonID = \(newAnonID)")
                
                let traits = ["anonymousId": anonID]
                
                print("MJ: Enabling Segment")
                self.segment.enable()
                
                print("MJ: Calling Identify = User:nil, Traits: \(traits), options: \(traits)")
                self.segment.identify(nil, traits: traits, options: traits)
                
                let anonIDAfterReset = self.segment.getAnonymousId()
                print("MJ: Segment AnonID After Reset= \(anonIDAfterReset)")
                
            }
            else {
                print("MJ: anonID != currentAnonID")
                self.waitForResetIn(anonID: anonID, afterDelay: afterDelay)
            }
        }
    }
    
    public func enable() {
        segment.enable()
    }
    
    public func disable() {
        segment.reset()
        segment.disable()
    }
    
    public func identify(userId: String, traits: [String: Any]?) {
        var userTraits = traits ?? [:]
        userTraits["userId"] = userId
        userTraits["anonymousId"] = segment.getAnonymousId()
        
        segment.identify(userId, traits: userTraits)
    }
    
    public func track<T: RawRepresentable>(screen: T, properties: [AnalyticsProperty: AnalyticsSerializable]?) where T.RawValue == String {
        let stringKeyedProperties = properties?.keyedByRawValue()
        segment.screen(screen.rawValue, properties: stringKeyedProperties)
    }
    
    public func track<T: RawRepresentable>(event: T, properties: [AnalyticsProperty: AnalyticsSerializable]?) where T.RawValue == String {
        
        var stringKeyedProperties = [AnalyticsProperty.RawValue: AnalyticsSerializable]()
        
        if let props = properties {
            stringKeyedProperties = props.keyedByRawValue()
        }
        
        segment.track(event.rawValue, properties: stringKeyedProperties, options: defaultSegmentOptions)
    }
    
    public func track(event: String, properties: [String: Any]?, value: String? = nil) {

        var segmentOptions = defaultSegmentOptions
        if let trackValue = value {
            segmentOptions["value"] = trackValue
        }
        
        segment.track(event, properties: properties, options: segmentOptions)
    }
    
}

public enum AnalyticsProperty: String {
    case context = "Context"
    case ShowLandmarkImage = "show_landmark_image"
    case isEnabled = "isEnabled"
    case FeatureFlagProvider = "FeatureFlagProvider"
    
}

public extension AnalyticsProperty {
    func rawValue(suffixing index: Int) -> String {
        return "\(rawValue) \(index)"
    }
}

public extension Dictionary where Key == AnalyticsProperty {
    func keyedByRawValue() -> [AnalyticsProperty.RawValue: Value] {
        return reduce(into: [AnalyticsProperty.RawValue: Value]()) { result, property in
            result[property.key.rawValue] = property.value
        }
    }
}

public protocol AnalyticsSerializable: CustomStringConvertible {}

extension String: AnalyticsSerializable {}
extension Bool: AnalyticsSerializable {}
extension Date: AnalyticsSerializable {}
extension Float: AnalyticsSerializable {}
extension Double: AnalyticsSerializable {}
extension Int: AnalyticsSerializable {}
extension Int8: AnalyticsSerializable {}
extension Int16: AnalyticsSerializable {}
extension Int32: AnalyticsSerializable {}
extension Int64: AnalyticsSerializable {}
extension UInt: AnalyticsSerializable {}
extension UInt8: AnalyticsSerializable {}
extension UInt16: AnalyticsSerializable {}
extension UInt32: AnalyticsSerializable {}
extension UInt64: AnalyticsSerializable {}
extension NSNumber: AnalyticsSerializable {}
extension Dictionary: AnalyticsSerializable {}
extension Array: AnalyticsSerializable {}
