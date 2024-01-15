//
//  RemoteConfigView.swift
//  FirebaseSample
//
//  Created by kotaro-seki on 2024/01/15.
//

import SwiftUI

struct RemoteConfigView: View {
    @State private var remoteConfigResult: String?
    @State private var remoteConfigValue: String?

    var body: some View {
        VStack {
            if let remoteConfigResult, let remoteConfigValue {
                Text("remoteConfigResult: \(remoteConfigResult)")
                Text("remoteConfigResult: \(remoteConfigValue)")
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            Button(action: {
                remoteConfigValue = FirebaseManager.shared.remoteConfigStringValue(forkey: "sampleString")
            }, label: {
                Text("update")
            })
        }
        .padding()
        .task {
            switch await FirebaseManager.shared.fetchAndActivateRemoteConfig() {
                case .success:
                    remoteConfigResult = "success"
                case .failure(let error):
                    remoteConfigResult = "failure error: \(error.localizedDescription)"
            }
            remoteConfigValue = FirebaseManager.shared.remoteConfigStringValue(forkey: "sampleString")
        }
    }
}

#Preview {
    RemoteConfigView()
}
