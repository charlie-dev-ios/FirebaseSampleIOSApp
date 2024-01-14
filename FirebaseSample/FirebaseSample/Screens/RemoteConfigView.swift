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
        Group {
            if let remoteConfigResult, let remoteConfigValue {
                VStack {
                    Text("remoteConfigResult: \(remoteConfigResult)")
                    Text("remoteConfigResult: \(remoteConfigValue)")
                }
                .padding()
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
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
