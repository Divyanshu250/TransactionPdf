//
//  Reachability.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//


import Foundation
import Network
import SystemConfiguration

class Reachability {
    
    /// Checks network connectivity based on OS version
    class func isConnectedToNetwork() -> Bool {
        if #available(iOS 12.0, *) {
            let monitor = NWPathMonitor()
            let semaphore = DispatchSemaphore(value: 0)
            var isConnected = false
            
            monitor.pathUpdateHandler = { path in
                isConnected = path.status == .satisfied
                semaphore.signal()
                monitor.cancel()
            }
            let queue = DispatchQueue(label: "NetworkMonitor")
            monitor.start(queue: queue)
            _ = semaphore.wait(timeout: .now() + 1) // Wait max 1 second
            return isConnected
        } else {
            // Legacy support for iOS versions < 12
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return false
            }
            
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                return false
            }
            
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            return isReachable && !needsConnection
        }
    }
}

