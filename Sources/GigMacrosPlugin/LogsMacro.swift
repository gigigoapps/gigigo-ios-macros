//
//  LogsMacro.swift
//
//
//  Created by Alejandro Jiménez on 17/1/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct LogManagerMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let subsystem = node.argumentList.first(where: { $0.label?.text == "subsystem" }),
            let category = node.argumentList.first(where: { $0.label?.text == "category" })
        else {
            fatalError("compiler bug: the macro does not have the correct arguments (subsystem, category)")
        }
        let enumLoglevel: DeclSyntax =
        """
        enum LogLevel: Int, Comparable {
            /// No log will be shown.
            case none = 0
            
            /// Only warnings and errors.
            case error = 1
            
            /// Errors and relevant information.
            case info = 2
            
            /// Request and Responses will be displayed.
            case debug = 3
            
            static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
                lhs.rawValue < rhs.rawValue
            }
        }
        """
        
        let logManager: DeclSyntax =
        """
        class LogManager: @unchecked Sendable {
            static let shared = LogManager()
            static let logger = Logger(subsystem: \(subsystem.expression), category: \(category.expression))
        
            var logLevel: LogLevel = .none
        }
        """
        return [
            enumLoglevel,
            logManager
        ]
    }
}

public struct LogDebugMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        let expression: ExprSyntax =
        """
        {
        if LogManager.shared.logLevel >= .debug {
            let message = \(argument)
            LogManager.logger.debug("\\(message)")
        }   
        }()
        """
        return expression
    }
}

public struct LogInfoMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        let expression: ExprSyntax =
        """
        {
        if LogManager.shared.logLevel >= .info {
            let message = \(argument)
            LogManager.logger.info("\\(message)")
        }
        }()
        """
        return expression
    }
}

public struct LogWarnMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        let expression: ExprSyntax =
        """
        {
        if LogManager.shared.logLevel >= .error {
            let message = \(argument)
            LogManager.logger.warning("\\(message)")
        }
        }()
        """
        return expression
    }
}

public struct LogErrorMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        let expression: ExprSyntax =
        """
        {
        if LogManager.shared.logLevel >= .error {
            guard let err = \(argument) as NSError? else { return }
            LogManager.logger.fault("\\(err.localizedDescription)\\n\\t⤷USER INFO: \\(err.userInfo)\\n")
        }
        }()
        """
        return expression
    }
}

@main
struct LogsMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LogManagerMacro.self,
        LogDebugMacro.self,
        LogInfoMacro.self,
        LogWarnMacro.self,
        LogErrorMacro.self
    ]
}
