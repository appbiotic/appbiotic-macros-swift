//  Copyright (c) 2024 Appbiotic Inc.
//  Licensed under Apache License v2.0 with Runtime Library Exception

import AppbioticMacros
import XCTest

enum ServiceState2: String, CaseIterable {
  case stopped
  case starting
  case running
  case stopping

  public init?(notificationName: Notification.Name) {
    if let domainRange = notificationName.rawValue.firstRange(of: "\(ServiceState.domain)."),
      domainRange.lowerBound == notificationName.rawValue.startIndex
    {
      let eventName = notificationName.rawValue[domainRange.upperBound...]
      self.init(rawValue: String(eventName))
    } else {
      return nil
    }
  }

  public var notificationName: Notification.Name {
    Notification.Name("\(ServiceState.domain).\(self.rawValue)")
  }
}

@NotificationNames(domain: "com.example")
enum ServiceState: String, CaseIterable {
  case stopped
  case starting
  case running
  case stopping
}

final class AppbioticMacrosUsageTests: XCTestCase {
  func testIntoNotificationName() throws {
    XCTAssertEqual(ServiceState.running.rawValue, "running")
    XCTAssertEqual(ServiceState.running.notificationName.rawValue, "com.example.running")
  }

  func testFromNotificationName() throws {
    XCTAssertEqual(
      ServiceState(notificationName: Notification.Name("com.example.stopped")), ServiceState.stopped
    )
  }

  func testFromNotificationNameFailure() throws {
    XCTAssertEqual(ServiceState(notificationName: Notification.Name("com.example.closed")), nil)
  }
}
