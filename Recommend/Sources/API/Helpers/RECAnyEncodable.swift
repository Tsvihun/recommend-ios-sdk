//
//  RECAnyEncodable.swift
//  Recommend
//
//  Created by Pavel Tsvihun on 06.11.2025.
//

import Foundation

public struct RECAnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
