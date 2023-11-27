// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let finishedEvent = try? JSONDecoder().decode(finishedEvent.self, from: jsonData)

import Foundation

// MARK: - finishedEvent
struct finishedEvent: Codable {
    let event: finishedEventClass?
}

// MARK: - finishedEventClass
struct finishedEventClass: Codable {
    let tournament: finishedTournament?
    let season: finishedSeason?
    let customId: String?
    let status: finishedStatus?
    let winnerCode: Int?
    let homeTeam: finishedHomeTeam?
    let awayTeam: finishedAwayTeam?
    let homeScore, awayScore: finishedScore?
    let coverage: Int?
    let time: finishedTime?
    let changes: finishedChanges?
    let hasGlobalHighlights, crowdsourcingDataDisplayEnabled: Bool?
    let id, bestOf: Int?
    let eventType: String?
    let startTimestamp: Int?
    let slug: String?
    let finalResultOnly, fanRatingEvent, showTotoPromo, isEditor: Bool?
    let crowdsourcingEnabled: Bool?
}

// MARK: - finishedScore
struct finishedScore: Codable {
    let current, display, period1, period2: Int?
}

// MARK: - finishedAwayTeam
struct finishedAwayTeam: Codable {
    let name, slug, shortName: String?
    let sport: finishedSport?
    let userCount: Int?
    let nameCode: String?
    let national: Bool?
    let type, id: Int?
    let country: finishedTime?
    let subTeams: [JSONAny]?
    let fullName: String?
    let teamColors: finishedTeamColors?
}

// MARK: - finishedTime
struct finishedTime: Codable {
}

// MARK: - finishedSport
struct finishedSport: Codable {
    let name, slug: String?
    let id: Int?
}

// MARK: - finishedTeamColors
struct finishedTeamColors: Codable {
    let primary, secondary, text: String?
}

// MARK: - finishedChanges
struct finishedChanges: Codable {
    let changes: [String]?
    let changeTimestamp: Int?
}

// MARK: - finishedHomeTeam
struct finishedHomeTeam: Codable {
    let name, slug, shortName: String?
    let sport: finishedSport?
    let userCount: Int?
    let nameCode: String?
    let national: Bool?
    let type, id: Int?
    let country: finishedCountry?
    let subTeams: [JSONAny]?
    let fullName: String?
    let teamColors: finishedTeamColors?
}

// MARK: - finishedCountry
struct finishedCountry: Codable {
    let alpha2, name: String?
}

// MARK: - finishedSeason
struct finishedSeason: Codable {
    let name, year: String?
    let editor: Bool?
    let id: Int?
}

// MARK: - finishedStatus
struct finishedStatus: Codable {
    let code: Int?
    let description, type: String?
}

// MARK: - finishedTournament
struct finishedTournament: Codable {
    let name, slug: String?
    let category: finishedCategory?
    let uniqueTournament: finishedUniqueTournament?
    let priority, id: Int?
}

// MARK: - finishedCategory
struct finishedCategory: Codable {
    let name, slug: String?
    let sport: finishedSport?
    let id: Int?
    let flag: String?
}

// MARK: - finishedUniqueTournament
struct finishedUniqueTournament: Codable {
    let name, slug: String?
    let category: finishedCategory?
    let userCount, id: Int?
    let country: finishedTime?
    let hasEventPlayerStatistics, crowdsourcingEnabled, hasPerformanceGraphFeature, displayInverseHomeAwayTeams: Bool?
}
