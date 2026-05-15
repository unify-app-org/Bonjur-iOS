//
//  MultipartFormData.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 09.05.26.
//

import Foundation

public struct MultipartFormData {
    
    public let boundary: String
    public private(set) var fields: [FormField]
    public private(set) var files: [FilePart]
    
    public init(
        boundary: String = UUID().uuidString,
        fields: [FormField] = [],
        files: [FilePart] = []
    ) {
        self.boundary = boundary
        self.fields = fields
        self.files = files
    }
    
    // MARK: - Mutating helpers
    
    public mutating func addField(name: String, value: String) {
        fields.append(FormField(name: name, value: value))
    }
    
    public mutating func addFile(
        name: String,
        fileName: String,
        mimeType: String,
        data: Data
    ) {
        files.append(FilePart(name: name, fileName: fileName, mimeType: mimeType, data: data))
    }
    
    /// Encodes an `Encodable` body as a JSON dictionary and appends each
    /// top-level key/value pair as a text form field.
    public mutating func mergeEncodableFields(_ encodable: Encodable) {
        guard let data = try? JSONEncoder().encode(encodable),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }
        for (key, value) in dict {
            addField(name: key, value: "\(value)")
        }
    }
    
    public mutating func addJSONField(name: String, encodable: Encodable) {
        guard let data = try? JSONEncoder().encode(encodable),
              let jsonString = String(data: data, encoding: .utf8) else { return }
        addField(name: name, value: jsonString)
    }
    
    // MARK: - Build body
    
    public func encode() -> Data {
        var body = Data()
        let crlf = "\r\n"
        
        for field in fields {
            body.append("--\(boundary)\(crlf)")
            body.append("Content-Disposition: form-data; name=\"\(field.name)\"\(crlf)\(crlf)")
            body.append("\(field.value)\(crlf)")
        }
        
        for file in files {
            body.append("--\(boundary)\(crlf)")
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.fileName)\"\(crlf)")
            body.append("Content-Type: \(file.mimeType)\(crlf)\(crlf)")
            body.append(file.data)
            body.append(crlf)
        }
        
        body.append("--\(boundary)--\(crlf)")
        return body
    }
}

// MARK: - Supporting types

public struct FormField {
    public let name: String
    public let value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

public struct FilePart {
    public let name: String
    public let fileName: String
    public let mimeType: String
    public let data: Data
    
    public init(name: String, fileName: String, mimeType: String, data: Data) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}

// MARK: - Data + String Append

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
