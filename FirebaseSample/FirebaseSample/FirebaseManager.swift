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

    func fetch() {
        remoteConfig?.fetch { (status, error) -> Void in
          if status == .success {
            print("aaaa status == .success")
              print("aaaa configValue", self.remoteConfig?.configValue(forKey: "sampleString").stringValue)
            self.remoteConfig?.activate { changed, error in
                print("aaaa activate", changed, error)
            }
          } else {
              print("aaaa status != .success")
              print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
        }
    }
}
