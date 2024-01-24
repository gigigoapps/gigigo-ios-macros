import GigMacros
import OSLog

#logManager(subsystem: "McDonaldsApp", category: "app")

// String literal
#logDebug("Debug test")
#logInfo("Info test")
#logWarn("Warning test")

// String object
let testString = "test"
#logDebug(testString)
#logInfo(testString)
#logWarn(testString)

// Errors
#logError(NSError())
#logError(nil)
