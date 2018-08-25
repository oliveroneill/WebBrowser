# WebBrowser

A small Swift library for opening URLs in the web browser from command line.

This was built for desktop Swift scripts and is compatible with Linux and
macOS.
I have not tested it on Linux yet.

## Installation
Add this to your Package.swift:
```swift
.package(url: "https://github.com/oliveroneill/WebBrowser.git", .upToNextMajor(from: "1.0.0")),
```

## Usage
```swift
import WebBrowser

do {
    try WebBrowser.open(url: URL(string: "http://google.com/")!)
} catch {
    // handle error
}
```
