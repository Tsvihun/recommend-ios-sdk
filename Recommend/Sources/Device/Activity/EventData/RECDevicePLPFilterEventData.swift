//
//  RECDevicePLPFilterEventData.swift
//  Recommend
//
//  Created by Pavel Tsvihun on 07.11.2025.
//

import Foundation

public final class RECDevicePLPFilterEventData: RECDeviceEventData {
    
    let plpFilters: RECAnyEncodable
    
    // MARK: - Init
    public init(plpFilters: RECAnyEncodable) {
        self.plpFilters = plpFilters
    }
    
    // MARK: - Coding
    enum CodingKeys: String, CodingKey {
        case plpFilters = "plp_filters"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(plpFilters, forKey: .plpFilters)
        try super.encode(to: encoder)
    }
    
}
