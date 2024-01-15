//
//  FirebaseManager.swift
//  FirebaseSample
//
//  Created by kotaro-seki on 2024/01/15.
//

import Foundation
import FirebaseCore
import FirebaseRemoteConfig

final class FirebaseManager {
    static let shared = FirebaseManager()

    private var remoteConfig: RemoteConfig?

    private init() {}

    func setup() {
        FirebaseApp.configure()
        setupRemoteConfig()
    }

    func setupRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
    }

    func addOnConfigUpdateListener() {
        remoteConfig?.addOnConfigUpdateListener(remoteConfigUpdateCompletion: { [weak self] update, error in
            self?.remoteConfig?.activate()
        })
    }

    func fetchAndActivateRemoteConfig() async -> Result<Void, Error> {
        do {
            // In order to read the Remote Config values, not only fetch but also activate needs to be called.
            try await remoteConfig?.fetchAndActivate()
            return .success(())
        } catch {
            print("Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    func remoteConfigStringValue(forkey key: RemoteConfigKeys) -> String? {
        remoteConfig?.configValue(forKey: key.rawValue).stringValue
    }

    func remoteConfigNumberValue(forkey key: RemoteConfigKeys) -> Int? {
        remoteConfig?.configValue(forKey: key.rawValue).numberValue as? Int
    }

    func remoteConfigDataValue(forkey key: RemoteConfigKeys) -> Data? {
        remoteConfig?.configValue(forKey: key.rawValue).dataValue
    }
}

enum RemoteConfigKeys: String {
    case sample
}
