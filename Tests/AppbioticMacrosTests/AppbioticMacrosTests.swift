//  Copyright (c) 2024 Appbiotic Inc.
//  Licensed under Apache License v2.0 with Runtime Library Exception

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(AppbioticMacrosPlugin)
  import AppbioticMacrosPlugin

  let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
    "NotificationNames": NotificationNamesMacro.self,
  ]
#endif

final class AppbioticMacrosTests: XCTestCase {
  func testNotificationNamesMacro() throws {

    #if canImport(AppbioticMacrosPlugin)
      assertMacroExpansion(
        """
        @NotificationNames(domain: "com.appbiotic.app.macros")
        public enum MyEvent: String, CaseIterable {
          case startedService
          case stoppedService
        }
        """,
        expandedSource: """
          public enum MyEvent: String, CaseIterable {
            case startedService
            case stoppedService

              public static let domain = "com.appbiotic.app.macros"

              public init?(notificationName: Notification.Name) {
                  if let domainRange = notificationName.rawValue.firstRange(of: "\\(MyEvent.domain)."),
                      domainRange.lowerBound == notificationName.rawValue.startIndex
                  {
                      let eventName = notificationName.rawValue[domainRange.upperBound...]
                      self.init(rawValue: String(eventName))
                  } else {
                      return nil
                  }
              }

              public var notificationName: Notification.Name {
                  Notification.Name("\\(MyEvent.domain).\\(self.rawValue)")
              }
          }
          """,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testMacro() throws {
    #if canImport(AppbioticMacrosPlugin)
      assertMacroExpansion(
        """
        #stringify(a + b)
        """,
        expandedSource: """
          (a + b, "a + b")
          """,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testMacroWithStringLiteral() throws {
    #if canImport(AppbioticMacrosPlugin)
      assertMacroExpansion(
        #"""
        #stringify("Hello, \(name)")
        """#,
        expandedSource: #"""
          ("Hello, \(name)", #""Hello, \(name)""#)
          """#,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }
}
