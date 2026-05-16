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
    
    public mutating func addField(
        name: String,
        value: String,
        contentType: String? = nil
    ) {
        guard let data = value.data(using: .utf8) else { return }
        fields.append(
            FormField(
                name: name,
                data: data,
                contentType: contentType
            )
        )
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
    public mutating func addJSONField(name: String, encodable: Encodable) {
        guard let data = try? JSONEncoder().encode(encodable) else { return }
        fields.append(
            FormField(
                name: name,
                data: data,
                contentType: "application/json; charset=utf-8"
            )
        )
    }
    
    // MARK: - Build body
    
    public func encode() -> Data {
        var body = Data()
        let crlf = "\r\n"
        
        for field in fields {
            body.append("--\(boundary)\(crlf)")
            body.append("Content-Disposition: form-data; name=\"\(field.name)\"\(crlf)")
            if let contentType = field.contentType {
                body.append("Content-Type: \(contentType)\(crlf)")
            }
            body.append(crlf)
            body.append(field.data)
            body.append(crlf)
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
    public let data: Data
    public let contentType: String?
    
    public init(
        name: String,
        data: Data,
        contentType: String? = nil
    ) {
        self.name = name
        self.data = data
        self.contentType = contentType
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
