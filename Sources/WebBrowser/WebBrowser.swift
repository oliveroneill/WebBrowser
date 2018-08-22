import Foundation

import ShellOut

/// An enum that houses functions to be called
public enum WebBrowser {
    /// Open the specified URL in the browser
    ///
    /// - Parameter url: The URL to open
    /// - Throws: If the command fails or there is no BROWSER environment variable
    /// set for Linux
    public static func open(url: URL) throws {
        #if os(Linux)
        try openForLinux(url: url)
        #elseif os(macOS)
        try openForMac(url: url)
        #else
        fatalError("Unsupported OS. Currently only MacOS and Linux are supported")
        #endif
    }

    /// WebBrowser related errors
    ///
    /// - browserVariableNotSet: If the BROWSER environment variable is not set
    /// for Linux
    public enum WebBrowserError: Error {
        case browserVariableNotSet
    }

    private static func openForMac(url: URL) throws {
        try shellOut(to: "open", arguments: ["\"\(url.absoluteString)\""])
    }

    private static func openForLinux(url: URL) throws {
        guard let browsers = ProcessInfo.processInfo.environment["BROWSER"] else {
            throw WebBrowserError.browserVariableNotSet
        }
        // $BROWSER can contain ':' delimited options, where each entry represents a
        // browser command
        for browser in browsers.split(separator: ":") {
            if browser.isEmpty {
                continue
            }
            // Each browser command can have %s to be replaced by a URL, %c needs to
            // be replaced with ':' and %% with '%'
            let cmd = browser
                .replacingOccurrences(of: "%s", with: url.absoluteString)
                .replacingOccurrences(of: "%c", with: ":")
                .replacingOccurrences(of: "%%", with: "%")
            let cmdList = cmd.split(separator: " ").map(String.init)
            let command = cmdList[0]
            // If there is no space in this command then we should append the URL
            // ourselves
            guard cmdList.count > 1 else {
                try shellOut(to: command, arguments: [url.absoluteString])
                return
            }
            try shellOut(to: command, arguments: Array(cmdList[1..<cmdList.count]))
        }
    }
}
