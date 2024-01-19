import GigMacros
import OSLog

enum LogLevel: Int {
    /// No log will be shown.
    case none = 0
    
    /// Only warnings and errors.
    case error = 1
    
    /// Errors and relevant information.
    case info = 2
    
    /// Request and Responses will be displayed.
    case debug = 3
}


func >= (levelA: LogLevel, levelB: LogLevel) -> Bool {
    return levelA.rawValue >= levelB.rawValue
}


class LogManager {
    static let shared = LogManager()
    static let logger = Logger(subsystem: "McDonaldsApp", category: "app")
    
    var logLevel: LogLevel = .none
}

#logDebug("Debug test")
#logInfo("Info test")
#logWarn("Warning test")
#logError(NSError())
