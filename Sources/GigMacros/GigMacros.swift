// The Swift Programming Language
// https://docs.swift.org/swift-book

@freestanding(declaration, names: arbitrary)
public macro logManager(subsystem: String, category: String) = #externalMacro(module: "GigMacrosPlugin", type: "LogManagerMacro")

@freestanding(expression)
public macro logDebug(_ message: String) = #externalMacro(module: "GigMacrosPlugin", type: "LogDebugMacro")

@freestanding(expression)
public macro logInfo(_ message: String) = #externalMacro(module: "GigMacrosPlugin", type: "LogInfoMacro")

@freestanding(expression)
public macro logWarn(_ message: String) = #externalMacro(module: "GigMacrosPlugin", type: "LogWarnMacro")

@freestanding(expression)
public macro logError(_ error: Error?) = #externalMacro(module: "GigMacrosPlugin", type: "LogErrorMacro")
