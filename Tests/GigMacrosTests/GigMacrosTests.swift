import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(GigMacrosPlugin)
import GigMacrosPlugin

let testMacros: [String: Macro.Type] = [
    "logManager": LogManagerMacro.self,
    "logDebug": LogDebugMacro.self,
    "logInfo": LogInfoMacro.self,
    "logWarn": LogWarnMacro.self,
    "logError": LogErrorMacro.self
]
#endif

final class GigMacrosTests: XCTestCase {
    func testLogManagerMacro() throws {
#if canImport(GigMacrosPlugin)
        assertMacroExpansion(
            """
            #logManager(subsystem: "SubsystemTest", category: "CategoryTest")
            """,
            expandedSource: """
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
            class LogManager: @unchecked Sendable {
                static let logger = Logger(subsystem: "SubsystemTest", category: "CategoryTest")
                private static let staticQueue = DispatchQueue(label: "logManagerStaticQueue")
                private var logLevelSynced: LogLevel = .none

                static var logLevel: LogLevel {
                    get {
                        self.staticQueue.sync {
                            self.logLevelSynced
                        }
                    }
                    set {
                        self.staticQueue.async(flags: .barrier) {
                            self.logLevelSynced = newValue
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
    
    func testDebugWithStringLiteral() throws {
#if canImport(GigMacrosPlugin)
        assertMacroExpansion(
            #"""
            #logDebug("Debug test")
            """#,
            expandedSource:
            #"""
            {
                if LogManager.logLevel >= .debug {
                    let message = "Debug test"
                    LogManager.logger.debug("\(message)")
                }
            }()
            """#,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testDebugWithStringObject() throws {
#if canImport(GigMacrosPlugin)
        assertMacroExpansion(
            #"""
            let testString = "test"
            #logDebug(testString)
            """#,
            expandedSource:
            #"""
            let testString = "test"
            {
                if LogManager.logLevel >= .debug {
                    let message = testString
                    LogManager.logger.debug("\(message)")
                }
            }()
            """#,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testInfoWithStringLiteral() throws {
#if canImport(GigMacrosPlugin)
        assertMacroExpansion(
            #"""
            #logInfo("Info test")
            """#,
            expandedSource:
            #"""
            {
                if LogManager.logLevel >= .info {
                    let message = "Info test"
                    LogManager.logger.info("\(message)")
                }
            }()
            """#,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testInfoWithStringObject() throws {
#if canImport(GigMacrosPlugin)
        assertMacroExpansion(
            #"""
            let testString = "test"
            #logInfo(testString)
            """#,
            expandedSource:
            #"""
            let testString = "test"
            {
                if LogManager.logLevel >= .info {
                    let message = testString
                    LogManager.logger.info("\(message)")
                }
            }()
            """#,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testWarningWithStringLiteral() throws {
#if canImport(GigMacrosPlugin)
        assertMacroExpansion(
            #"""
            #logWarn("Warning test")
            """#,
            expandedSource:
            #"""
            {
                if LogManager.logLevel >= .error {
                    let message = "Warning test"
                    LogManager.logger.warning("\(message)")
                }
            }()
            """#,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testWarningWithStringObject() throws {
#if canImport(GigMacrosPlugin)
        assertMacroExpansion(
            #"""
            let testString = "test"
            #logWarn(testString)
            """#,
            expandedSource:
            #"""
            let testString = "test"
            {
                if LogManager.logLevel >= .error {
                    let message = testString
                    LogManager.logger.warning("\(message)")
                }
            }()
            """#,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testErrorWithErrorObject() throws {
#if canImport(GigMacrosPlugin)
        assertMacroExpansion(
            #"""
            #logError(NSError())
            """#,
            expandedSource:
            #"""
            {
                if LogManager.logLevel >= .error {
                    guard let err = NSError() as NSError? else {
                        return
                    }
                    LogManager.logger.fault("\(err.localizedDescription)\n\t⤷USER INFO: \(err.userInfo)\n")
                }
            }()
            """#,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testErrorWithNil() throws {
#if canImport(GigMacrosPlugin)
        assertMacroExpansion(
            #"""
            #logError(nil)
            """#,
            expandedSource:
            #"""
            {
                if LogManager.logLevel >= .error {
                    guard let err = nil as NSError? else {
                        return
                    }
                    LogManager.logger.fault("\(err.localizedDescription)\n\t⤷USER INFO: \(err.userInfo)\n")
                }
            }()
            """#,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
