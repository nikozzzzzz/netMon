import Cocoa

public class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var networkMonitor: NetworkMonitor
    private var timer: Timer?
    
    public init() {
        statusBar = NSStatusBar.system
        // Variable length to accommodate changing text width
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        networkMonitor = NetworkMonitor()
        
        if let button = statusItem.button {
            button.title = "Initializing..."
            button.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        }
        
        setupMenu()
        startMonitoring()
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        let launchAtLoginItem = NSMenuItem(title: "Start at Login", action: #selector(toggleLaunchAtLogin(_:)), keyEquivalent: "")
        launchAtLoginItem.target = self
        launchAtLoginItem.state = LaunchAtLogin.isEnabled ? .on : .off
        menu.addItem(launchAtLoginItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit netMon", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    @objc private func toggleLaunchAtLogin(_ sender: NSMenuItem) {
        let newState = sender.state == .off
        LaunchAtLogin.isEnabled = newState
        sender.state = newState ? .on : .off
    }
    
    private func startMonitoring() {
        // Update every 1 second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateNetworkStats()
        }
    }
    
    private func updateNetworkStats() {
        let stats = networkMonitor.update()
        let downText = NetworkMonitor.formatBytes(stats.downloadSpeed)
        let upText = NetworkMonitor.formatBytes(stats.uploadSpeed)
        
        DispatchQueue.main.async { [weak self] in
            if let button = self?.statusItem.button {
                button.title = "↓ \(downText) ↑ \(upText)"
            }
        }
    }
}
