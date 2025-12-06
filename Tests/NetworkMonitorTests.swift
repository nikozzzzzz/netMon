import XCTest
import netMonCore

class NetworkMonitorTests: XCTestCase {
    
    func testFormatBytes() {
        XCTAssertEqual(NetworkMonitor.formatBytes(500), "500 B/s")
        XCTAssertEqual(NetworkMonitor.formatBytes(1024), "1.0 KB/s")
        XCTAssertEqual(NetworkMonitor.formatBytes(1536), "1.5 KB/s")
        XCTAssertEqual(NetworkMonitor.formatBytes(1024 * 1024), "1.0 MB/s")
        XCTAssertEqual(NetworkMonitor.formatBytes(1024 * 1024 * 1024), "1.0 GB/s")
    }
    
    func testMonitorInitialization() {
        let monitor = NetworkMonitor()
        // Initial update might be 0 because time delta is small or 0
        let stats = monitor.update()
        XCTAssertGreaterThanOrEqual(stats.uploadSpeed, 0)
        XCTAssertGreaterThanOrEqual(stats.downloadSpeed, 0)
    }
}
