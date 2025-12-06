import Foundation
import SystemConfiguration

public struct NetworkStats {
    public let uploadSpeed: Double // bytes per second
    public let downloadSpeed: Double // bytes per second
}

public class NetworkMonitor {
    private var lastUploadBytes: UInt64 = 0
    private var lastDownloadBytes: UInt64 = 0
    private var lastCheckTime: TimeInterval = 0
    
    public init() {
        let (down, up) = getBytes()
        lastDownloadBytes = down
        lastUploadBytes = up
        lastCheckTime = Date().timeIntervalSince1970
    }
    
    public func update() -> NetworkStats {
        let (currentDown, currentUp) = getBytes()
        let currentTime = Date().timeIntervalSince1970
        
        let timeDelta = currentTime - lastCheckTime
        
        // Avoid division by zero
        guard timeDelta > 0 else {
            return NetworkStats(uploadSpeed: 0, downloadSpeed: 0)
        }
        
        // Handle overflow or reset (if computer restarted or interface reset, though unlikely to wrap UInt64 quickly)
        let downDelta = (currentDown >= lastDownloadBytes) ? (currentDown - lastDownloadBytes) : 0
        let upDelta = (currentUp >= lastUploadBytes) ? (currentUp - lastUploadBytes) : 0
        
        let downSpeed = Double(downDelta) / timeDelta
        let upSpeed = Double(upDelta) / timeDelta
        
        lastDownloadBytes = currentDown
        lastUploadBytes = currentUp
        lastCheckTime = currentTime
        
        return NetworkStats(uploadSpeed: upSpeed, downloadSpeed: downSpeed)
    }
    
    private func getBytes() -> (down: UInt64, up: UInt64) {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        guard getifaddrs(&ifaddr) == 0 else { return (0, 0) }
        defer { freeifaddrs(ifaddr) }
        
        var ptr = ifaddr
        var totalDown: UInt64 = 0
        var totalUp: UInt64 = 0
        
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            
            guard let interface = ptr?.pointee else { continue }
            
            // Look for AF_LINK (link layer interface)
            if interface.ifa_addr.pointee.sa_family == UInt8(AF_LINK) {
                let name = String(cString: interface.ifa_name)
                
                // Filter for common active interfaces (en0, en1, etc.) and exclude loopback (lo0)
                // We typically want en0 (WiFi) or en1 (Ethernet) etc.
                // A simple heuristic is to exclude lo* and bridge* and p2p* if we want external traffic.
                // For "network monitor", usually we want everything that goes out.
                // But often summing everything includes local traffic.
                // Let's include en* for now as it's the most standard for Mac internet.
                if name.hasPrefix("en") {
                    if let data = interface.ifa_data {
                        let networkData = data.assumingMemoryBound(to: if_data.self)
                        totalDown += UInt64(networkData.pointee.ifi_ibytes)
                        totalUp += UInt64(networkData.pointee.ifi_obytes)
                    }
                }
            }
        }
        
        return (totalDown, totalUp)
    }
    
    public static func formatBytes(_ bytes: Double) -> String {
        let kb = 1024.0
        let mb = kb * 1024.0
        let gb = mb * 1024.0
        
        if bytes >= gb {
            return String(format: "%.1f GB/s", bytes / gb)
        } else if bytes >= mb {
            return String(format: "%.1f MB/s", bytes / mb)
        } else if bytes >= kb {
            return String(format: "%.1f KB/s", bytes / kb)
        } else {
            return String(format: "%.0f B/s", bytes)
        }
    }
}
