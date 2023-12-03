// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let upcomingMatches = try? JSONDecoder().decode(UpcomingMatches.self, from: jsonData)

import Foundation
import OptionallyDecodable // https://github.com/idrougge/OptionallyDecodable

// MARK: - UpcomingMatches
struct UpcomingMatches: Codable {
    let events: [UpcomingEvent]?
}

// MARK: - UpcomingEvent
struct UpcomingEvent: Codable {
    let tournament: UpcomingTournament?
    let customId: String?
    let status: UpcomingStatus?
    let homeTeam, awayTeam: UpcomingTeam?
    let homeScore, awayScore: UpcomingScore?
    let coverage: Int?
    let time: UpcomingTime?
    let changes: UpcomingChanges?
    let hasGlobalHighlights, crowdsourcingDataDisplayEnabled: Bool?
    let id, bestOf: Int?
    @OptionallyDecodable var eventType: UpcomingEventType?
    let startTimestamp: Int?
    let slug: String?
    let finalResultOnly, isEditor, crowdsourcingEnabled: Bool?
    let winnerCode: Int?
    let roundInfo: UpcomingRoundInfo?
    let lastPeriod: String?
}

// MARK: - UpcomingScore
struct UpcomingScore: Codable {
    let current, display, period1, period2: Int?
    let period3, period4, normaltime: Int?
}

// MARK: - UpcomingTeam
struct UpcomingTeam: Codable {
    let name, slug, shortName: String?
    let sport: UpcomingSport?
    let userCount: Int?
    let nameCode: String?
    let type, id: Int?
    let country: UpcomingCountry?
    let subTeams: [JSONAny]?
    let teamColors: UpcomingTeamColors?
}

// MARK: - UpcomingCountry
struct UpcomingCountry: Codable {
    let alpha2, name: String?
}

// MARK: - UpcomingSport
struct UpcomingSport: Codable {
    @OptionallyDecodable var name: UpcomingSportName?
    @OptionallyDecodable var slug: UpcomingSportSlug?
    let id: Int?
}

enum UpcomingSportName: String, Codable {
    case eSports = "E-sports"
}

enum UpcomingSportSlug: String, Codable {
    case esports = "esports"
}

// MARK: - UpcomingTeamColors
struct UpcomingTeamColors: Codable {
    @OptionallyDecodable var primary: UpcomingAry?
    @OptionallyDecodable var secondary: UpcomingAry?
    @OptionallyDecodable var text: UpcomingText?
}

enum UpcomingAry: String, Codable {
    case the52B030 = "#52b030"
}

enum UpcomingText: String, Codable {
    case ffffff = "#ffffff"
}

// MARK: - UpcomingChanges
struct UpcomingChanges: Codable {
    let changeTimestamp: Int?
    let changes: [String]?
}

enum UpcomingEventType: String, Codable {
    case bestOf = "best_of"
}

// MARK: - UpcomingRoundInfo
struct UpcomingRoundInfo: Codable {
    let round: Int?
}

// MARK: - UpcomingStatus
struct UpcomingStatus: Codable {
    let code: Int?
    @OptionallyDecodable var description: UpcomingDescription?
    @OptionallyDecodable var type: UpcomingType?
}

enum UpcomingDescription: String, Codable {
    case canceled = "Canceled"
    case ended = "Ended"
    case firstGame = "First game"
    case notStarted = "Not started"
    case secondGame = "Second game"
    case the1StHalf = "1st half"
    case thirdGame = "Third game"
}

enum UpcomingType: String, Codable {
    case canceled = "canceled"
    case finished = "finished"
    case inprogress = "inprogress"
    case notstarted = "notstarted"
}

// MARK: - UpcomingTime
struct UpcomingTime: Codable {
    let currentPeriodStartTimestamp: Int?
}

// MARK: - UpcomingTournament
struct UpcomingTournament: Codable {
    let name, slug: String?
    let category: UpcomingCategory?
    let uniqueTournament: UpcomingUniqueTournament?
    let priority, id: Int?
}

// MARK: - UpcomingCategory
struct UpcomingCategory: Codable {
    @OptionallyDecodable var name: UpcomingCategoryName?
    @OptionallyDecodable var slug: UpcomingCategorySlug?
    let sport: UpcomingSport?
    let id: Int?
    @OptionallyDecodable var flag: UpcomingFlag?
}

enum UpcomingFlag: String, Codable {
    case csgo = "csgo"
    case dota2 = "dota-2"
    case other = "other"
}

enum UpcomingCategoryName: String, Codable {
    case csGo = "CS:GO"
    case dota2 = "Dota 2"
    case other = "Other"
}

enum UpcomingCategorySlug: String, Codable {
    case csgo = "csgo"
    case dota2 = "dota2"
    case other = "other"
}

// MARK: - UpcomingUniqueTournament
struct UpcomingUniqueTournament: Codable {
    let name, slug: String?
    let category: UpcomingCategory?
    let userCount: Int?
    let crowdsourcingEnabled, hasPerformanceGraphFeature: Bool?
    let id: Int?
    let hasEventPlayerStatistics, displayInverseHomeAwayTeams: Bool?
}
