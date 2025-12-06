# netMon

**netMon** is a lightweight, open-source macOS status bar application that monitors your network speed in real-time. It displays your current upload and download speeds directly in the menu bar.

![netMon Screenshot](https://via.placeholder.com/600x100?text=netMon+Status+Bar+Example)

## Features

- **Real-time Monitoring**: Updates every second.
- **Minimalist Design**: Sits quietly in your status bar.
- **Autostart**: Option to launch automatically at login.
- **Native**: Written in Swift, lightweight and efficient.

## Installation

1.  Go to the [Releases](../../releases) page.
2.  Download the latest `netMon.dmg`.
3.  Open the DMG and drag `netMon` to your Applications folder.
4.  Launch the app!

## Development

### Prerequisites

- macOS 11.0 or later
- Xcode 12.0 or later (for Swift toolchain)

### Building Locally

1.  Clone the repository:
    ```bash
    git clone https://github.com/YOUR_USERNAME/netMon.git
    cd netMon
    ```

2.  Run the build script:
    ```bash
    ./scripts/build_and_package.sh
    ```
    This will compile the app and create a `netMon.dmg` in the project root. Note that without signing credentials, the app will be unsigned and may require right-click -> Open to run.

## Release Process (Maintainers Only)

To create a signed and notarized release, you need an Apple Developer ID and a Notary profile.

1.  **Set Environment Variables**:
    ```bash
    export DEV_ID="Developer ID Application: Your Name (TEAMID)"
    export NOTARY_PROFILE="YourNotaryProfile"
    ```

2.  **Run the Build Script**:
    ```bash
    ./scripts/build_and_package.sh
    ```

3.  **Distribute**:
    Upload the generated `netMon.dmg` to GitHub Releases.

## License

MIT License. See [LICENSE](LICENSE) for details.
