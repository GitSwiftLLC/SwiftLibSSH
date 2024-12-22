# SwiftLibSSH

A Swift wrapper for `libssh2` using `OpenSSL`, designed to simplify SSH connections and encryption in Swift applications. This package is a Swift Package Manager (SPM) version of [sshterm/ssh](https://github.com/sshterm/ssh).

SwiftLibSSH is a modern, thread-safe Swift library for SSH, leveraging the power of libssh2. It provides a robust and efficient implementation for secure remote connections and operations, designed with concurrency in mind to meet the demands of contemporary Swift applications.

## Installation

To install SwiftLibSSH, add it to your `Package.swift` file using the Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/GitSwiftLLC/SwiftLibSSH.git", from: "1.0.0")
]
```

This package relies on [SwiftCSSH](https://github.com/GitSwiftLLC/SwiftCSSH) and [SwiftCSSL](https://github.com/GitSwiftLLC/SwiftCSSL) as dependencies to provide robust SSH and SSL support.

## Acknowledgements

SwiftLibSSH is based on the original [sshterm/ssh](https://github.com/sshterm/ssh) project.

## License

Refer to the [LICENSE](LICENSE) file for more information.