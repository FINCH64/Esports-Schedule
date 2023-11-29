//
//  UpcomingMatch.swift
//  ESportsTracker
//
//  Created by f1nch on 29.11.23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let upcomingMatches = try? JSONDecoder().decode(UpcomingMatches.self, from: jsonData)

import Foundation

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
    let homeScore, awayScore: UpcomingAwayScore?
    let coverage: Int?
    let time: UpcomingAwayScore?
    let changes: UpcomingChanges?
    let hasGlobalHighlights, crowdsourcingDataDisplayEnabled: Bool?
    let id, bestOf: Int?
    let eventType: UpcomingEventType?
    let startTimestamp: Int?
    let slug: String?
    let finalResultOnly, isEditor, crowdsourcingEnabled: Bool?
    let winnerCode: Int?
    let roundInfo: UpcomingRoundInfo?
}

// MARK: - UpcomingAwayScore
struct UpcomingAwayScore: Codable {
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
    let name: UpcomingSportName?
    let slug: UpcomingSlug?
    let id: Int?
}

enum UpcomingSportName: String, Codable {
    case eSports = "E-sports"
}

enum UpcomingSlug: String, Codable {
    case esports = "esports"
}

// MARK: - UpcomingTeamColors
struct UpcomingTeamColors: Codable {
    let primary, secondary: UpcomingAry?
    let text: UpcomingText?
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
    let changes: [UpcomingChange]?
}

enum UpcomingChange: String, Codable {
    case statusCode = "status.code"
    case statusDescription = "status.description"
    case statusType = "status.type"
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
    let description: UpcomingDescription?
    let type: UpcomingType?
}

enum UpcomingDescription: String, Codable {
    case canceled = "Canceled"
    case notStarted = "Not started"
}

enum UpcomingType: String, Codable {
    case canceled = "canceled"
    case notstarted = "notstarted"
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
    let name: UpcomingCategoryName?
    let slug: UpcomingFlag?
    let sport: UpcomingSport?
    let id: Int?
    let flag: UpcomingFlag?
}

enum UpcomingFlag: String, Codable {
    case csgo = "csgo"
    case dota2 = "dota2"
    case flagDota2 = "dota-2"
    case lol = "lol"
    case other = "other"
}

enum UpcomingCategoryName: String, Codable {
    case csGo = "CS:GO"
    case dota2 = "Dota 2"
    case loL = "LoL"
    case other = "Other"
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
