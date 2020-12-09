import UIKit
//import Alamofire

// MARK: Properties
var List: [Player] = []

struct Player: Codable {
    let steamName: String
    let steamID: Int
    let steamImage: URL?
}

struct Stats: Codable {
    // 表示用
    
}

struct StatsArray: Codable {
    let item: [Stats]?
}


