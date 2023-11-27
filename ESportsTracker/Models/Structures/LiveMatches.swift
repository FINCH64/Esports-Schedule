// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let liveMatches = try? JSONDecoder().decode(LiveMatches.self, from: jsonData)

import Foundation

//описывает то,каким образом будет выглядеть структура каждого матча(Event) и объекта хранящего все матчи(LiveMatches)

// MARK: - LiveMatches
struct LiveMatches: Codable {
    let events: [Event]?
}

// MARK: - Event
struct Event: Codable {
    let tournament: Tournament?
    let season: Season?
    let customID: String?
    let status: Status?
    let winnerCode: Int?
    var homeTeam, awayTeam: Team?
    let homeScore, awayScore: Score?
    let coverage: Int?
    let time: Time?
    let changes: Changes?
    let hasGlobalHighlights, crowdsourcingDataDisplayEnabled: Bool?
    let id, bestOf: Int?
    let eventType: String?
    let startTimestamp: Int?
    let slug: String?
    let finalResultOnly, fanRatingEvent, showTotoPromo, isEditor, crowdsourcingEnabled: Bool?
    let roundInfo: RoundInfo?
    let lastPeriod: String?

    enum CodingKeys: String, CodingKey {
        case tournament, season
        case customID = "customId"
        case status, winnerCode, homeTeam, awayTeam, homeScore, awayScore, coverage, time, changes, hasGlobalHighlights, crowdsourcingDataDisplayEnabled, id, bestOf, eventType, startTimestamp, slug, finalResultOnly,fanRatingEvent, showTotoPromo, isEditor, crowdsourcingEnabled, roundInfo, lastPeriod
    }
}

// MARK: - Score
struct Score: Codable {
    let current, display, period1, period2: Int?
    
    let normaltime: Int?
}

// MARK: - Team
struct Team: Codable {
    let name, slug, shortName: String?
    let sport: Sport?
    let userCount: Int?
    let nameCode: String?
    let national: Bool?
    let type, id: Int?
    let country: Country?
    let subTeams: [JSONAny]?
    let fullName: String?
    let teamColors: TeamColors?
    var teamLogoData: Data?
}

// MARK: - Country
struct Country: Codable {
    let alpha2, name: String?
}

// MARK: - Sport
struct Sport: Codable {
    let name: String?
    let slug: String?
    let id: Int?
}

// MARK: - TeamColors
struct TeamColors: Codable {
    let primary, secondary, text: String?
}

// MARK: - Changes
struct Changes: Codable {
    let changes: [String]?
    let changeTimestamp: Int?
}

// MARK: - Season
struct Season: Codable {
    let name, year: String?
    let editor: Bool?
    let id: Int?
}

// MARK: - RoundInfo
struct RoundInfo: Codable {
    let round: Int?
}

// MARK: - Status
struct Status: Codable {
    let code: Int?
    let description, type: String?
}

// MARK: - Time
struct Time: Codable {
    let currentPeriodStartTimestamp: Int?
}

// MARK: - Tournament
struct Tournament: Codable {
    let name, slug: String?
    let category: Category?
    let uniqueTournament: UniqueTournament?
    let priority, competitionType, id: Int?
}

// MARK: - Category
struct Category: Codable {
    let name, slug: String?
    let sport: Sport?
    let id: Int?
    let flag: String?
}

// MARK: - UniqueTournament
struct UniqueTournament: Codable {
    let name, slug: String?
    let category: Category?
    let userCount, id: Int?
    let country: UniqueTournamentCountry?
    let hasEventPlayerStatistics, crowdsourcingEnabled, hasPerformanceGraphFeature, displayInverseHomeAwayTeams: Bool?
}

// MARK: - UniqueTournamentCountry
struct UniqueTournamentCountry: Codable {
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
