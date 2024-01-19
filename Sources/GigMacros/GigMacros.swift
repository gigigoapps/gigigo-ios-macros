// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro logDebug(_ message: String) = #externalMacro(module: "GigMacrosPlugin", type: "LogDebugMacro")

@freestanding(expression)
public macro logInfo(_ message: String) = #externalMacro(module: "GigMacrosPlugin", type: "LogInfoMacro")

@freestanding(expression)
public macro logWarn(_ message: String) = #externalMacro(module: "GigMacrosPlugin", type: "LogWarnMacro")

@freestanding(expression)
public macro logError(_ error: Error) = #externalMacro(module: "GigMacrosPlugin", type: "LogErrorMacro")
