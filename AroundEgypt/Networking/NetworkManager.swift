//
//  NetworkManager.swift
//  AroundEgypt
//
//  Created by MagyElias on 21/01/2025.
//

import Network

class NetworkManager {
    static let shared = NetworkManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private(set) var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
