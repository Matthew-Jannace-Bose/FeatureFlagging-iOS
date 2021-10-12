//
//  ContentView.swift
//  Landmarks
//
//  Created by Matthew Jannace on 10/15/20.
//

import SwiftUI

struct SegmentTestContentView: View {
    @State var showImage = false
    
    var body: some View {
        VStack {
            MapView()
                .edgesIgnoringSafeArea(.top)
                .frame(height:300)
            if (showImage) {
                CircleImage()
                    .offset(y: -130)
                    .padding(.bottom, -130)
                    .onAppear(perform: {
                        checkUpdates()
                    })
            }
            VStack(alignment: .leading) {
                Text("Turtle Rock")
                    .font(.title)
                HStack {
                    Text("Joshua Tree National Park")
                        .font(.subheadline)
                    Spacer()
                    Text("California")
                        .font(.subheadline)
                }
            }
            .padding()
            Spacer()
            VStack() {
                Spacer()
                HStack() {
                    Spacer()
                    Button(action:{
                        checkUpdates()
                    }) {
                        Text("Refresh")
                    }
                    Spacer()
                    Button(action:{
                        sendAnalytics()
                    }) {
                        Text("Send Event")
                    }
                    Spacer()
                }
                Spacer()
                Button(action:{
                    identify()
                }) {
                    Text("Identify User")
                }
                Spacer()
            
                HStack() {
                    Spacer()
                   
                    Spacer()
                    Button(action:{
                        resetAndRetainAnonID(async:true)
                    }) {
                        Text("ASYNC: Reset User w/AnonID")
                    }
                    Spacer()
                }
                Spacer()
                Button(action:{
                    resetAndRetainAnonID(async:false)
                }) {
                    Text("SYNC: Reset User w/AnonID")
                }
                Spacer()
                HStack() {
                    Spacer()
                    Button(action:{
                        reset()
                    }) {
                        Text("Reset")
                    }
                    Spacer()
                }
            }
            
            
            
        }.onAppear() {
            
        }
    }

    func checkUpdates() {
        
//        FeatureFlag.sharedInstance.refresh(){
//            showImage = FeatureFlag.sharedInstance.isEnabled(key:FeatureFlagKeys.ShowLandmarkImage) ?? true
        showImage = FeatureFlag.sharedInstance.isEnabled(key:FeatureFlagKeys.ShowLandmarkImage)

        sendAnalytics()
//        }
    }
    
    func sendAnalytics() {
        //            bAnalytics.sharedInstance.track(event: AnalyticsProperty.ShowLandmarkImage, properties:
        //                                                [AnalyticsProperty.isEnabled : FeatureFlag.sharedInstance.isEnabled(key:FeatureFlagKeys.ShowLandmarkImage)!])
        
//        bAnalytics.sharedInstance.track(event: AnalyticsProperty.ShowLandmarkImage, properties:
//                                            [AnalyticsProperty.isEnabled : FeatureFlag.sharedInstance.isEnabled(key:FeatureFlagKeys.ShowLandmarkImage),
//                                             AnalyticsProperty.FeatureFlagProvider : "FireBase"])
    }

    func identify() {
        bAnalytics.sharedInstance.identify("matt@bose.com")
    }

    func resetAndRetainAnonID(async:Bool) {
        bAnalytics.sharedInstance.resetAndRetainAnonID(async: async)
    }
    
    func reset() {
        bAnalytics.sharedInstance.reset()
    }
}


struct SegmentTestContentView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentTestContentView()
    }
}
