//
//  FirebaseManager.swift
//  FirebaseSample
//
//  Created by kotaro-seki on 2024/01/15.
//

import Combine
import Foundation
import FirebaseCore
import FirebaseRemoteConfig

final class FirebaseManager {
    static let shared = FirebaseManager()

    private var remoteConfig: RemoteConfig?
    private var remoteConfigChangesSubject = PassthroughSubject<Void, Never>()

    private init() {}

    func setup() {
        FirebaseApp.configure()
        setupRemoteConfig()
    }

    func setupRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #endif
        remoteConfig?.configSettings = settings
        addOnConfigUpdateListener()
    }

    func addOnConfigUpdateListener() {
        remoteConfig?.addOnConfigUpdateListener(remoteConfigUpdateCompletion: { [weak self] update, error in
            self?.remoteConfig?.activate()
            self?.remoteConfigChangesSubject.send()
        })
    }

    func fetchRemoteConfig() async -> Result<Void, Error> {
        do {
            try await remoteConfig?.fetch()
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    func activateRemoteConfig() async -> Result<Void, Error> {
        do {
            try await remoteConfig?.activate()
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    func remoteConfigStringValue(forkey key: RemoteConfigKeys) -> String? {
        remoteConfig?.configValue(forKey: key.rawValue).stringValue
    }

    func remoteConfigIntValue(forkey key: RemoteConfigKeys) -> Int? {
        remoteConfig?.configValue(forKey: key.rawValue).numberValue as? Int
    }

    func remoteConfigDataValue(forkey key: RemoteConfigKeys) -> Data? {
        remoteConfig?.configValue(forKey: key.rawValue).dataValue
    }

    func observeRemoteConfigChanges() -> AnyPublisher<Void, Never> {
        remoteConfigChangesSubject.eraseToAnyPublisher()
    }
}

enum RemoteConfigKeys: String {
    case sampleString
    case sampleInt
    case sampleData
}
