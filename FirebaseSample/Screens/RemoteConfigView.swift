//
//  RemoteConfigView.swift
//  FirebaseSample
//
//  Created by kotaro-seki on 2024/01/15.
//

import Foundation
import Combine
import SwiftUI

struct RemoteConfigView: View {
    @State private var fetchResult: String?
    @State private var activateResult: String?
    @State private var sampleString: String?
    @State private var sampleInt: String?
    @State private var sampleData: String?
    @State private var changesDetected: Bool = false
    @State private var task: Task<Void, Never>?
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        List {
            Section("values") {
                label(title: "fetchResult", value: fetchResult)
                label(title: "activateResult", value: activateResult)
                label(title: "sampleString", value: sampleString)
                label(title: "sampleInt", value: sampleInt)
                label(title: "changesDetected", value: changesDetected.description)
            }
            Section("sample data") {
                Text(sampleData ?? "nil")
            }
            Section("actions") {
                fetchButton
                activateButton
                loadSampleStringButton
                loadSampleIntButton
                loadSampleDataButton
            }
        }
        .onAppear {
            observeChanges()
        }
    }

    private var fetchResultLabel: some View {
        HStack {
            Text("fetchResult")
            Spacer()
            Text(fetchResult ?? "nil")
                .foregroundStyle(.secondary)
        }
    }

    private func label(title: String, value: String?) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value ?? "nil")
                .foregroundStyle(.secondary)
        }
    }

    private var fetchButton: some View {
        Button(action: {
            task = Task {
                await fetch()
            }
        }, label: {
            Text("fetch")
        })
    }

    private var activateButton: some View {
        Button(action: {
            task = Task {
                await activate()
            }
        }, label: {
            Text("activate")
        })
    }

    private var loadSampleStringButton: some View {
        Button(action: {
            loadSampleString()
        }, label: {
            Text("loadSampleString")
        })
    }

    private var loadSampleIntButton: some View {
        Button(action: {
            loadSampleInt()
        }, label: {
            Text("loadSampleInt")
        })
    }

    private var loadSampleDataButton: some View {
        Button(action: {
            loadSampleData()
        }, label: {
            Text("loadSampleData")
        })
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

    private func observeChanges() {
        FirebaseManager.shared.observeRemoteConfigChanges()
            .receive(on: DispatchQueue.main)
            .sink {
                changesDetected = true
            }.store(in: &cancellables)
    }
}

struct SampleStruct: Decodable {
    let message: String
}

#Preview {
    RemoteConfigView()
}
