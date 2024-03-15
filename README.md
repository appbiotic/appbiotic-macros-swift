# AppbioitcMacros

A collection of Swift macros to reduce boilerplate for building applications.

## Installation

Package dependency:

```swift
.package(url: "https://github.com/appbiotic/appbiotic-macros-swift", from: "0.1.0")
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
