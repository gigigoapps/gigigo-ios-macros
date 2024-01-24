# gigigo-ios-macros
Swift Macros for Gigigo apps

## Logs Macros

In a file (AppDelegate or similar), you can declare the LogManager using the macro `#logManager(subsystem: String, category: String)`. Previous that, you must import OSLog module.
Then, you must to set log level of the app:

* none: No log will be shown.
* error: Only warnings and errors.
* info: Errors and relevant information.
* debug: All kind of logs are displayed 

You can set the log level at app startup like this:

```swift
LogManager.shared.logLevel = .info
```

Then, you can log any kind of information using `#log...`:

* `#logDebug(String)`: Use this kind of log for debugging messages like request/response information
* `#logInfo(String)`: Use this log for relevant information events. Like "user did log out". "App version: v3.0.0"
* `#logWarn(String)`: Use this log for explaining that something unexpected happened. "Can't find user in DB"
* `#logWarn(NSError)`: Similar to #logWarn but can log a NSError directly

Examples:

```swift
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
```
