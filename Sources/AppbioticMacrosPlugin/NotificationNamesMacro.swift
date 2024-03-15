//  Copyright (c) 2024 Appbiotic Inc.
//  Licensed under Apache License v2.0 with Runtime Library Exception

import SwiftSyntax
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

    var prefix: String? = nil
    guard let labeledExprList = node.arguments?.as(LabeledExprListSyntax.self) else {
      throw NotificationNamesMacroError.invalidArguments
    }

    try labeledExprList.forEach { labeledExpr in
      guard let label = labeledExpr.label else {
        throw NotificationNamesMacroError.invalidArguments
      }
      switch label.text {
      case "prefix":
        guard let stringExpr = labeledExpr.expression.as(StringLiteralExprSyntax.self),
          let value = stringExpr.representedLiteralValue
        else {
          throw NotificationNamesMacroError.invalidArguments
        }
        prefix = value
      default:
        throw NotificationNamesMacroError.invalidArguments
      }
    }

    let cases = enumDecl.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .compactMap { $0.elements.first?.name.text }
    let variable = VariableDeclSyntax(
      modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: TokenSyntax.keyword(.public))
      },
      bindingSpecifier: .keyword(.var),
      bindings: PatternBindingListSyntax([
        PatternBindingSyntax(
          pattern: IdentifierPatternSyntax(identifier: .identifier("notificationName")),
          typeAnnotation: TypeAnnotationSyntax(
            colon: .colonToken(), type: IdentifierTypeSyntax(name: .identifier("Notification.Name"))
          ),
          accessorBlock: AccessorBlockSyntax(
            accessors: AccessorBlockSyntax.Accessors(
              AccessorDeclListSyntax(
                [
                  AccessorDeclSyntax(
                    accessorSpecifier: .keyword(.get),
                    body: CodeBlockSyntax(
                      leftBrace: .leftBraceToken(leadingTrivia: .space),
                      statements: CodeBlockItemListSyntax(
                        [
                          CodeBlockItemSyntax(
                            item: .expr(
                              ExprSyntax(
                                SwitchExprSyntax(
                                  subject: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                                  cases: SwitchCaseListSyntax {
                                    for caseName in cases {
                                      SwitchCaseSyntax(
                                        "case .\(raw: caseName): return Notification.Name(\"\(raw: prefix ?? "")\(raw: caseName)\")"
                                      )
                                    }
                                  }
                                ))
                            ))
                        ]
                      ),
                      rightBrace: .rightBraceToken(leadingTrivia: .newline)
                    ))
                ]
              )
            )
          )
        )
      ])
    )
    return [
      DeclSyntax(variable)
    ]
  }
}
