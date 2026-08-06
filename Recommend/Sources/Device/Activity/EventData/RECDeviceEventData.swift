//
//  RECDeviceEventData.swift
//  Recommend
//
//  Created by Pavel Tsvihun on 06.11.2025.
//

import Foundation

public class RECDeviceEventData: Encodable { }

public final class RECDevicePLPEventData: RECDeviceEventData {
    let categoryCode: String
    let pageNumber: Int
    let sortMode: String
    let isDefaultSort: Bool
    let hasFilters: Bool

    public init(
        categoryCode: String,
        pageNumber: Int,
        sortMode: String,
        isDefaultSort: Bool,
        hasFilters: Bool
    ) {
        self.categoryCode = categoryCode
        self.pageNumber = pageNumber
        self.sortMode = sortMode
        self.isDefaultSort = isDefaultSort
        self.hasFilters = hasFilters
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case categoryCode = "category_code"
        case pageNumber = "page_number"
        case sortMode = "sort_mode"
        case isDefaultSort = "is_default_sort"
        case hasFilters = "has_filters"
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categoryCode, forKey: .categoryCode)
        try container.encode(pageNumber, forKey: .pageNumber)
        try container.encode(sortMode, forKey: .sortMode)
        try container.encode(isDefaultSort, forKey: .isDefaultSort)
        try container.encode(hasFilters, forKey: .hasFilters)
        try super.encode(to: encoder)
    }
}
