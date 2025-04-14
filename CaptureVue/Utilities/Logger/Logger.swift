//
//  Logger.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/4/25.
//

import Foundation


enum log{
    
    enum LogLevel{
        case info
        case warning
        case error
        case success
        
        fileprivate var prefix: String {
            switch self {
            case .info: return "INFO ℹ️"
            case .warning: return "WARNING ⚠️"
            case .error: return "ERROR ❌"
            case .success: return "SUCCESS ✅"
            }
        }
    }
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            return "\((file as NSString).lastPathComponent):\(line) \(function)"
        }
    }
    
    static func getDate() -> String{
     let time = Date()
     let timeFormatter = DateFormatter()
     timeFormatter.dateFormat = "HH:mm:ss"
     let stringDate = timeFormatter.string(from: time)
     return stringDate
    }
    
    fileprivate static func handleLog(level: LogLevel, str: String, shouldLogContext: Bool, showCurrentThread: Bool, context: Context){
        let date = log.getDate()
        
        let logComponents = ["[\(level.prefix)]", str]
        
        var fullString = logComponents.joined(separator: " ")
        if shouldLogContext{
            fullString += " ➡ \(context.description) "
        }
        if showCurrentThread{
            let thread = Thread.current.description
            fullString += " ➡ [\(thread)]"
        }
        
        let fullStringDate =  "\(date) " + fullString
        
        #if DEBUG
        print(fullStringDate)
        #endif
    }
    
    
    static func info<T: CustomStringConvertible>(_ str: T, shouldLogContext: Bool = true, showCurrentThread: Bool = false, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        log.handleLog(level: .info, str: str.description, shouldLogContext: shouldLogContext, showCurrentThread: showCurrentThread , context: context)
    }
    
    static func warning<T: CustomStringConvertible>(_ str: T, shouldLogContext: Bool = true, showCurrentThread: Bool = false, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        log.handleLog(level: .warning, str: str.description, shouldLogContext: shouldLogContext, showCurrentThread: showCurrentThread, context: context)
    }
    
    static func error<T: CustomStringConvertible>(_ str: T, shouldLogContext: Bool = true, showCurrentThread: Bool = false, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        log.handleLog(level: .error, str: str.description, shouldLogContext: shouldLogContext, showCurrentThread: showCurrentThread, context: context)
    }
    
    static func success<T: CustomStringConvertible>(_ str: T, shouldLogContext: Bool = true, showCurrentThread: Bool = false, file: String = #file, function: String = #function, line: Int = #line){
        let context = Context(file: file, function: function, line: line)
        log.handleLog(level: .success, str: str.description, shouldLogContext: shouldLogContext, showCurrentThread: showCurrentThread, context: context)
    }
}
