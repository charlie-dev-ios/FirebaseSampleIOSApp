//
//  FirebaseManager.swift
//  FirebaseSample
//
//  Created by kotaro-seki on 2024/01/15.
//

import Foundation
import FirebaseCore

final class FirebaseManager {
    static let shared = FirebaseManager()

    private init() {}

    func setup() {
        FirebaseApp.configure()
    }
}
