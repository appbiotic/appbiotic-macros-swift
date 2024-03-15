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
        @NotificationNames(prefix: "com.appbiotic.app.macros.")
        public enum MyEvent {
            case startedService
            case stoppedService
        }
        """,
        expandedSource: """
          public enum MyEvent {
              case startedService
              case stoppedService

              public var notificationName: Notification.Name {
                  get {
                      switch self {
                      case .startedService:
                          return Notification.Name("com.appbiotic.app.macros.startedService")
                      case .stoppedService:
                          return Notification.Name("com.appbiotic.app.macros.stoppedService")
                      }
                  }
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
