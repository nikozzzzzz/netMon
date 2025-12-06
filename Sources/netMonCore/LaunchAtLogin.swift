import Foundation

class LaunchAtLogin {
    private static let id = "com.nikospapadopulos.netMon"
    
    private static var launchAgentDir: URL {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("LaunchAgents")
    }
    
    private static var launchAgentURL: URL {
        launchAgentDir.appendingPathComponent("\(id).plist")
    }

    static var isEnabled: Bool {
        get { FileManager.default.fileExists(atPath: launchAgentURL.path) }
        set { newValue ? enable() : disable() }
    }

    private static func enable() {
        guard let execPath = Bundle.main.executablePath else { return }
        
        // Ensure directory exists
        try? FileManager.default.createDirectory(at: launchAgentDir, withIntermediateDirectories: true)
        
        let plistContent = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>\(id)</string>
            <key>ProgramArguments</key>
            <array>
                <string>\(execPath)</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>ProcessType</key>
            <string>Interactive</string>
        </dict>
        </plist>
        """
        
        try? plistContent.write(to: launchAgentURL, atomically: true, encoding: .utf8)
    }

    private static func disable() {
        try? FileManager.default.removeItem(at: launchAgentURL)
    }
}
