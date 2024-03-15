//  Copyright (c) 2024 Appbiotic Inc.
//  Licensed under Apache License v2.0 with Runtime Library Exception

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AppbioticAppMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StringifyMacro.self,
    NotificationNamesMacro.self,
  ]
}
