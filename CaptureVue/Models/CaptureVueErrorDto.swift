//
//  CaptureVueError.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/11/24.
//

import Foundation

struct CaptureVueErrorDto: Codable, Error {
    let msg: String?
    let code: Int
    let reason: String?
}

struct HttpStatusCode: Codable, Comparable {
    let value: Int
    let description: String
    
    init(value: Int, description: String) {
        self.value = value
        self.description = description
    }
    
    // Conform to Comparable protocol
    static func < (lhs: HttpStatusCode, rhs: HttpStatusCode) -> Bool {
        return lhs.value < rhs.value
    }
    
    // Static HTTP status codes
    static let `continue` = HttpStatusCode(value: 100, description: "Continue")
    static let switchingProtocols = HttpStatusCode(value: 101, description: "Switching Protocols")
    static let processing = HttpStatusCode(value: 102, description: "Processing")
    static let ok = HttpStatusCode(value: 200, description: "OK")
    static let created = HttpStatusCode(value: 201, description: "Created")
    static let accepted = HttpStatusCode(value: 202, description: "Accepted")
    static let noContent = HttpStatusCode(value: 204, description: "No Content")
    static let badRequest = HttpStatusCode(value: 400, description: "Bad Request")
    static let unauthorized = HttpStatusCode(value: 401, description: "Unauthorized")
    static let forbidden = HttpStatusCode(value: 403, description: "Forbidden")
    static let notFound = HttpStatusCode(value: 404, description: "Not Found")
    static let internalServerError = HttpStatusCode(value: 500, description: "Internal Server Error")
    static let serviceUnavailable = HttpStatusCode(value: 503, description: "Service Unavailable")
    // Additional status codes can be defined as needed
    
    // Method to check if the status code represents success
    var isSuccess: Bool {
        return (200...299).contains(value)
    }
    
    // Overriding the description
    func description(_ newDescription: String) -> HttpStatusCode {
        return HttpStatusCode(value: self.value, description: newDescription)
    }
}

enum HttpStatusCode1: Int, Codable {
    case continueCode = 100
    case switchingProtocols = 101
    case processing = 102
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    case serviceUnavailable = 503

    var description: String {
        switch self {
        case .continueCode:
            return "Continue"
        case .switchingProtocols:
            return "Switching Protocols"
        case .processing:
            return "Processing"
        case .ok:
            return "OK"
        case .created:
            return "Created"
        case .accepted:
            return "Accepted"
        case .nonAuthoritativeInformation:
            return "Non-Authoritative Information"
        case .noContent:
            return "No Content"
        case .resetContent:
            return "Reset Content"
        case .partialContent:
            return "Partial Content"
        case .multipleChoices:
            return "Multiple Choices"
        case .movedPermanently:
            return "Moved Permanently"
        case .found:
            return "Found"
        case .seeOther:
            return "See Other"
        case .notModified:
            return "Not Modified"
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .internalServerError:
            return "Internal Server Error"
        case .serviceUnavailable:
            return "Service Unavailable"
        }
    }
}
