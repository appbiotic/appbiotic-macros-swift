//  Copyright (c) 2024 Appbiotic Inc.
//  Licensed under Apache License v2.0 with Runtime Library Exception

import AppbioticMacros

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")
