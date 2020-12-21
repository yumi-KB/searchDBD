import UIKit

// MARK: - Struct

/* resolveVanityURL */
struct ResponseVanity: Codable{
    let steamid: String
}
struct ResultVanity: Codable {
    let response: ResponseVanity
}

/* getPlayerSummaries */
struct Player: Codable {
    let steamid: String
    let personaname: String
    let avatarfull: URL
}
struct ResponsePlayers: Codable {
    let players: [Player]
}
struct ResultPlayer: Codable {
    let response: ResponsePlayers
}

/* getUserStatsForGame */
struct Stats: Codable {
    let name: String
    let value : Double
}
struct PlayerStats: Codable {
    let steamID: String
    let stats: [Stats]
}
struct ResultStats: Codable {
    let playerstats: PlayerStats
}
