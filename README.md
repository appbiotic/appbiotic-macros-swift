# AppbioticMacros

A collection of Swift macros to reduce boilerplate for building applications.

## Installation

Package dependency:

```swift
.package(url: "https://github.com/appbiotic/appbiotic-macros-swift", exact: "0.2.0")
```

Target dependency:

```swift
.product(name: "AppbioticMacros", package: "appbiotic-macros-swift")
```

## Usage

### prefix

```swift
import AppbioticMacros
import NotificationCenter

@NotificationNames(prefix: "com.example.app.")
public enum AppEvent {
    case startedSomething
    case stoppedSomething
}
```

Expands to:

```swift
import AppbioticMacros
import NotificationCenter

public enum AppEvent {
    case startedSomething
    case stoppedSomething

    public var notificationName: Notification.Name {
        get {
            switch self {
            case .startedService:
                return Notification.Name("com.example.app.startedSomething")
            case .stoppedService:
                return Notification.Name("com.example.app.startedSomething")
            }
        }
    }
}
```

## Support

This software package is provided on an "as-is" basis. Community-based support is available in
[discussions](https://github.com/appbiotic/appbiotic-macros-swift/discussions). Filed
[issues](https://github.com/appbiotic/appbiotic-macros-swift/issues) may be renamed, split,
deduplicated, or moved to a discussion, for organizational clarity purposes.
