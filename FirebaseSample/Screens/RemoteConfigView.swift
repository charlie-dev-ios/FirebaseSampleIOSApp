//
//  RemoteConfigView.swift
//  FirebaseSample
//
//  Created by kotaro-seki on 2024/01/15.
//

import SwiftUI

struct RemoteConfigView: View {
    @State private var fetchResult: String?
    @State private var activateResult: String?
    @State private var sampleString: String?
    @State private var sampleInt: String?
    @State private var sampleData: String?
    @State private var task: Task<Void, Never>?

    var body: some View {
        VStack {
            buttons
            results
        }
        .padding()
    }

    private var results: some View {
        VStack {
            Text("fetchResult: \(fetchResult ?? "nil")")
            Text("activateResult: \(activateResult ?? "nil")")
            Text("sampleString: \(sampleString ?? "nil")")
            Text("sampleInt: \(sampleInt ?? "nil")")
            Text("sampleData: \(sampleData ?? "nil")")
        }
    }

    private var buttons: some View {
        VStack {
            Button(action: {
                task = Task {
                    await fetch()
                }
            }, label: {
                Text("fetch")
            })
            Button(action: {
                task = Task {
                    await activate()
                }
            }, label: {
                Text("activate")
            })
            Button(action: {
                loadSampleString()
            }, label: {
                Text("loadSampleString")
            })
            Button(action: {
                loadSampleInt()
            }, label: {
                Text("loadSampleInt")
            })
            Button(action: {
                loadSampleData()
            }, label: {
                Text("loadSampleData")
            })
        }
    }

    private func fetch() async {
        fetchResult = "\(await FirebaseManager.shared.fetchRemoteConfig())"
    }

    private func activate() async {
        activateResult = "\(await FirebaseManager.shared.activateRemoteConfig())"
    }

    private func loadSampleString() {
        sampleString = FirebaseManager.shared.remoteConfigStringValue(forkey: .sampleString)
    }

    private func loadSampleInt() {
        sampleInt = String(describing: FirebaseManager.shared.remoteConfigIntValue(forkey: .sampleInt))
    }

    private func loadSampleData() {
        guard let data = FirebaseManager.shared.remoteConfigDataValue(forkey: .sampleData),
              let sampleStruct = try? JSONDecoder().decode(SampleStruct.self, from: data) else {
            return
        }
        sampleData = "\(sampleStruct)"
    }
}

struct SampleStruct: Decodable {
    let message: String
}

#Preview {
    RemoteConfigView()
}
