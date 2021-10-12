////
////  SplitTestContentView.swift
////  FeatureFlagging
////
////  Created by Matthew Jannace on 1/19/21.
////
//
//import SwiftUI
//
//struct SplitTestContentView: View {
//    @State var showImage = false
//    @State var counter = 0
//    @State var ready = false
//    let useSegment = true
//
//    var body: some View {
//        VStack {
//            MapView()
//                .edgesIgnoringSafeArea(.top)
//                .frame(height:300)
//            if (showImage) {
//                CircleImage()
//                    .offset(y: -130)
//                    .padding(.bottom, -130)
//                    .onAppear(perform: {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                            checkUpdates()
//                        }
//                    })
//                    .accessibility(identifier: "circleImage")
//            }
//            VStack(alignment: .leading) {
//                Text("Turtle Rock")
//                    .font(.title)
//                HStack {
//                    Text("Joshua Tree National Park")
//                        .font(.subheadline)
//                    Spacer()
//                    Text("California")
//                        .font(.subheadline)
//                }
//            }
//            .padding()
//            Spacer()
//            VStack() {
//                HStack () {
//                Text("Iteration:")
//                    Text("\(counter)")
//                        .accessibility(identifier: "itterationTracker")
//                }
//            }
//            Spacer()
//            VStack() {
//                Spacer()
//                HStack() {
//                    Spacer()
//                    Button(action:{
//                        initialize()
//                    }) {
//                        Text("Initialize FF")
//                    }
//                    .accessibility(identifier: "initializer")
//                    .disabled(ready)
//                    Spacer()
//
//                    Button(action:{
//                        sendAnalytics()
//                    }) {
//                        Text("Send Event")
//                    }
//                    .accessibility(identifier: "sendEvent")
//                    .disabled(!ready)
//                    Spacer()
//                }
//                Spacer()
//                HStack(){
//                    Spacer()
//                    Button(action:{
//                        deInitialize()
//                    }) {
//                        Text("deInitialize FF")
//                    }
//                    .accessibility(identifier: "deInitialize")
//                    .disabled(!ready)
//                    Spacer()
//                    Button(action:{
//                        increment()
//                    }) {
//                        Text("increment")
//                    }
//                    .accessibility(identifier: "increment")
//                    .disabled(ready)
//                    Spacer()
//                }
//                Spacer()
//                if(ready) {
//                    Text("Split Ready")
//                    .accessibility(identifier: "sdkReady")
//                } else {
//                    Text("Split Not Ready")
//                    .accessibility(identifier: "sdkNotReady")
//                }
//                Spacer()
//            }
//        }
//    }
//
//    func increment(){
//        counter+=1
//    }
//
//    func initialize() {
//        print("initialize: Counter Value: \(counter)")
//        if (useSegment) {
//            bAnalytics.sharedInstance.identify("\(counter)")
//        }
//        FeatureFlag.sharedInstance.initalize(userKey: "\(counter)") {
//            ready = true
//            checkUpdates()
//        }
//    }
//
//    func deInitialize() {
//        print("deInitialize: Counter Value: \(counter)")
//        if (useSegment) {
//            bAnalytics.sharedInstance.reset()
//        }
//        FeatureFlag.sharedInstance.deInitialize() {
//            ready = false
//        }
//    }
//
//    func checkUpdates() {
//        showImage = FeatureFlag.sharedInstance.isEnabled(key:FeatureFlagKeys.ShowLandmarkImage)
//    }
//
//    func sendAnalytics() {
//        signUpEvents()
//        buyEvents()
//    }
//
//
//    func signUpEvents() {
//    //This is a 50/50 Split Everyone that saw the image clicked Create Account
//        print("Sending Event:")
//
//        var properties: [String:Any] = ["seenImage": showImage]
//        var eventType = ""
//        var value = 0.0
//
//
//        if (showImage) {
//            eventType = "CLICKED_CREATE_ACCOUNT"
//            value = 1.0
//        } else {
//            eventType = "CLICKED_FREE_ACCOUNT"
//        }
//
//        properties["value"] = "\(value)"
//
//        if (useSegment) {
//            bAnalytics.sharedInstance.track(event: eventType,
//                                            properties: properties,
//                                            value: "\(value)")
//        } else {
//            let result = FeatureFlag.sharedInstance.track(trafficType: "user", eventType: eventType, value: value, properties: properties)
//            print("Track Result: \(result)")
//        }
//    }
//
//
//
//    func buyEvents() {
//        //This is a 80% Split of those that saw the image clicked Buy
//
//        print("Sending Event:")
//
//        var properties: [String:Any] = ["seenImage": showImage]
//        var eventType = ""
//        var value = 0.0
//
//        if (showImage && probability(probFalse: 0.2, probTrue: 0.8)) {
//            eventType = "CLICKED_BUY"
//            value = Double(randomNumber(probabilities:[0.2,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]))
//        } else if (!showImage && probability(probFalse: 0.2, probTrue: 0.8)) {
//            eventType = "CLICKED_ADD_WISHLIST"
//            value = Double(randomNumber(probabilities:[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]))
//        } else if ( probability(probFalse: 0.5, probTrue: 0.5) ) {
//            eventType = "CLICKED_BUY"
//            value = Double(randomNumber(probabilities:[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.2]))
//        } else {
//            eventType = "CLICKED_ADD_WISHLIST"
//            value = Double(randomNumber(probabilities:[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]))
//        }
//
//        properties["value"] = "\(value)"
//
//        if (useSegment) {
//            bAnalytics.sharedInstance.track(event: eventType,
//                                            properties: properties,
//                                            value: "\(value)")
//        } else {
//            let result = FeatureFlag.sharedInstance.track(trafficType: "user", eventType: eventType, value: value, properties: properties)
//            print("Track Result: \(result)")
//        }
//    }
//}
//
//func probability( probFalse: Double, probTrue: Double ) -> Bool {
//
//    var probabilities = [Double]()
//    probabilities.append(probFalse)
//    probabilities.append(probTrue)
//
//    let probability = randomNumber(probabilities: probabilities)
//
//    return (probability == 0 ? false : true)
//}
//
//func randomNumber(probabilities: [Double]) -> Int {
//
//    // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
//    let sum = probabilities.reduce(0, +)
//    // Random number in the range 0.0 <= rnd < sum :
//    let rnd = Double.random(in: 0.0 ..< sum)
//    // Find the first interval of accumulated probabilities into which `rnd` falls:
//    var accum = 0.0
//    for (i, p) in probabilities.enumerated() {
//        accum += p
//        if rnd < accum {
//            return i
//        }
//    }
//    // This point might be reached due to floating point inaccuracies:
//    return (probabilities.count - 1)
//}
//
//struct SplitTestContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplitTestContentView()
//    }
//}
//
//
//
////func sendAnalytics() {
////    //            bAnalytics.sharedInstance.track(event: AnalyticsProperty.ShowLandmarkImage, properties:
////    //                                                [AnalyticsProperty.isEnabled : FeatureFlag.sharedInstance.isEnabled(key:FeatureFlagKeys.ShowLandmarkImage)!])
////
////    bAnalytics.sharedInstance.track(event: AnalyticsProperty.ShowLandmarkImage, properties:
////                                        [AnalyticsProperty.isEnabled : FeatureFlag.sharedInstance.isEnabled(key:FeatureFlagKeys.ShowLandmarkImage),
////                                         AnalyticsProperty.FeatureFlagProvider : "FireBase"])
////}
////
