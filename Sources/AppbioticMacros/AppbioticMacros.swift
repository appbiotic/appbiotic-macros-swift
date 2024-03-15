//  Copyright (c) 2024 Appbiotic Inc.
//  Licensed under Apache License v2.0 with Runtime Library Exception

// TODO: Replace placeholder stringify macro when custom freestanding macro is developed

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) =
  #externalMacro(module: "AppbioticMacrosPlugin", type: "StringifyMacro")

@attached(member, names: arbitrary)
public macro NotificationNames(prefix: String) =
  #externalMacro(module: "AppbioticMacrosPlugin", type: "NotificationNamesMacro")
