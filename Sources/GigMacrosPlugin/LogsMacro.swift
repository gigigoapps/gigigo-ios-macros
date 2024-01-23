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
        let message = \(argument)
        if LogManager.shared.logLevel >= .debug {
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
        let message = \(argument)
        if LogManager.shared.logLevel >= .info {
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
        let message = \(argument)
        if LogManager.shared.logLevel >= .error {
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
        guard let err = \(argument) as NSError? else { return }
        if LogManager.shared.logLevel >= .error {
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
        LogDebugMacro.self,
        LogInfoMacro.self,
        LogWarnMacro.self,
        LogErrorMacro.self
    ]
}
