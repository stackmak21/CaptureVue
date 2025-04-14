//
//  NetworkLogger.swift
//  CaptureVue
//
//  Created by Paris Makris on 14/4/25.
//

import Foundation


class NetworkLogger {
    
    static func log(request: URLRequest) {
        print("\n📤📤📤📤📤📤📤 OUTGOING REQUEST 📤📤📤📤📤📤📤")
        defer { print("📤📤📤📤📤📤📤 END REQUEST 📤📤📤📤📤📤📤\n") }

        let url = request.url?.absoluteString ?? "-"
        let components = URLComponents(string: url)
        let method = request.httpMethod ?? "-"
        let path = components?.path ?? "-"
        let query = components?.query.map { "?\($0)" } ?? ""
        let host = components?.host ?? "-"

        print("🔹 URL: \(url)")
        print("🔹 METHOD: \(method)")
        print("🔹 PATH: \(path)\(query)")
        print("🔹 HOST: \(host)")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("🔹 HEADERS:")
            for (key, value) in headers {
                print("   \(key): \(value)")
            }
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8), !bodyString.isEmpty {
            print("🔹 BODY:")
            print(bodyString)
        }
    }
    
    static func log(response: HTTPURLResponse?, data: Data?, error: Error?) {
        print("\n📥📥📥📥📥📥📥 INCOMING RESPONSE 📥📥📥📥📥📥📥")
        defer { print("📥📥📥📥📥📥📥 END RESPONSE 📥📥📥📥📥📥📥\n") }

        guard let response = response else {
            print("⚠️ No response received")
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
            }
            return
        }

        let url = response.url?.absoluteString ?? "-"
        let components = URLComponents(string: url)
        let path = components?.path ?? "-"
        let query = components?.query.map { "?\($0)" } ?? ""
        let host = components?.host ?? "-"

        print("🔸 URL: \(url)")
        print("🔸 STATUS CODE: \(response.statusCode)")
        print("🔸 PATH: \(path)\(query)")
        print("🔸 HOST: \(host)")

        if !response.allHeaderFields.isEmpty {
            print("🔸 HEADERS:")
            for (key, value) in response.allHeaderFields {
                print("   \(key): \(value)")
            }
        }

        if let data = data,
           let bodyString = String(data: data, encoding: .utf8), !bodyString.isEmpty {
            print("🔸 BODY:")
            print(bodyString)
        }

        if let error = error {
            print("❌ ERROR: \(error.localizedDescription)")
        }
    }
}



//class NetworkLogger{
//    
//    static func log(request: URLRequest) {
//       print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
//       defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
//       let urlAsString = request.url?.absoluteString ?? ""
//       let urlComponents = URLComponents(string: urlAsString)
//       let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
//       let path = "\(urlComponents?.path ?? "")"
//       let query = "\(urlComponents?.query ?? "")"
//       let host = "\(urlComponents?.host ?? "")"
//       var output = """
//       \(urlAsString) \n\n
//       \(method) \(path)?\(query) HTTP/1.1 \n
//       HOST: \(host)\n
//       """
//       for (key,value) in request.allHTTPHeaderFields ?? [:] {
//          output += "\(key): \(value) \n"
//       }
//       if let body = request.httpBody {
//          output += "\n \(String(data: body, encoding: .utf8) ?? "")"
//       }
//       print(output)
//    }
//    
//    
//    static func log(response: HTTPURLResponse?, data: Data?, error: Error?) {
//       print("\n - - - - - - - - - - INCOMMING - - - - - - - - - - \n")
//       defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
//       let urlString = response?.url?.absoluteString
//       let components = NSURLComponents(string: urlString ?? "")
//       let path = "\(components?.path ?? "")"
//       let query = "\(components?.query ?? "")"
//       var output = ""
//       if let urlString = urlString {
//          output += "\(urlString)"
//          output += "\n\n"
//       }
//       if let statusCode =  response?.statusCode {
//          output += "HTTP \(statusCode) \(path)?\(query)\n"
//       }
//       if let host = components?.host {
//          output += "Host: \(host)\n"
//       }
//       for (key, value) in response?.allHeaderFields ?? [:] {
//          output += "\(key): \(value)\n"
//       }
//       if let body = data {
//          output += "\n\(String(data: body, encoding: .utf8) ?? "")\n"
//       }
//       if error != nil {
//          output += "\nError: \(error!.localizedDescription)\n"
//       }
//       print(output)
//    }
//}
