//  Copyright (c) 2024 Appbiotic Inc.
//  Licensed under Apache License v2.0 with Runtime Library Exception

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum NotificationNamesMacroError: Error {
  case invalidArguments
  case notAnEnum
}

public struct NotificationNamesMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
      throw NotificationNamesMacroError.notAnEnum
    }

    let enumName = enumDecl.name.text
    var domain: String? = nil
    guard let labeledExprList = node.arguments?.as(LabeledExprListSyntax.self) else {
      throw NotificationNamesMacroError.invalidArguments
    }

    try labeledExprList.forEach { labeledExpr in
      guard let label = labeledExpr.label else {
        throw NotificationNamesMacroError.invalidArguments
      }
      switch label.text {
      case "domain":
        guard let stringExpr = labeledExpr.expression.as(StringLiteralExprSyntax.self),
          let value = stringExpr.representedLiteralValue
        else {
          throw NotificationNamesMacroError.invalidArguments
        }
        domain = value
      default:
        throw NotificationNamesMacroError.invalidArguments
      }
    }

    guard let domain = domain else {
      throw NotificationNamesMacroError.invalidArguments
    }

    return [
      DeclSyntax(
        try VariableDeclSyntax(
          SyntaxNodeString(stringLiteral: "public static let domain = \"\(domain)\""))),
      DeclSyntax(
        try InitializerDeclSyntax(
          SyntaxNodeString(stringLiteral: "public init?(notificationName: Notification.Name)")
        ) {
          ExprSyntax(
            """
            if let domainRange = notificationName.rawValue.firstRange(of: "\\(\(raw: enumName).domain)."),
                domainRange.lowerBound == notificationName.rawValue.startIndex
            {
                let eventName = notificationName.rawValue[domainRange.upperBound...]
                self.init(rawValue: String(eventName))
            } else {
                return nil
            }
            """)
        }),
      DeclSyntax(
        try VariableDeclSyntax(
          SyntaxNodeString(
            stringLiteral: """
              public var notificationName: Notification.Name {
                  Notification.Name("\\(\(enumName).domain).\\(self.rawValue)")
              }
              """))),
    ]
  }
}
