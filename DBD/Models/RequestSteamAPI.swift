import UIKit
//import Alamofire
//
//enum AFError: Error{
//    case responsetError
//    case parseError
//}
//
// MARK: - Struct
struct ResponseVanity: Codable{
    let steamid: String
}
struct ResultVanity: Codable {
    let response: ResponseVanity
}

struct Player: Codable {
    let steamid: String
    let personaname: String
    let avatarfull: URL?
}
struct ResponsePlayers: Codable {
    let players: [Player]
}
struct ResultPlayer: Codable {
    let response: ResponsePlayers
}

struct Stats: Codable {
    let name: String
    let value : Float
}
struct PlayerStats: Codable {
    let steamID: String
    let stats: [Stats]
}
struct ResultStats: Codable {
    let playerstats: PlayerStats
}
//
//
//// MARK: - Class
//class RequestSteamAPI {
//    
//    // MARK: Properties
//    // steamAPIアクセス用のkey
//    let steamKey = "A96399B2B4BD19AF214EBD58F6BF2689"
//    // ゲームID
//    let dbd = "381210"
//    let input: String
//    
//    var steamID: String = ""
//    var playerName: String = ""
//    var playerImage: URL?
//    
//    
//    // MARK: Initialization
//    init(input: String) {
//        self.input = input
//    }
//    
//    
//    // MARK: Private Methods
//    func validate() throws -> String {
//        guard !((self.input).isEmpty) else {
//            throw ValidationError.invalidLength
//        }
//        guard (self.input).count <= 40 else {
//            throw ValidationError.invalidLength
//        }
//        guard isVanityURL(self.input) else {
//            throw ValidationError.invalidString
//        }
//    }
//        
//        do {
//            try resolveVanityURL(self.input)
//        } catch {
//            
//            guard isNumber(self.input) else {
//                throw ValidationError.invalidString
//            }
//            self.steamID = self.input
//            print("only number?: \(self.steamID)")
//            return self.steamID
//        }
//        // try resolveVanityURL()の処理が終わる前に実行されてしまう
//        // 非同期処理されている？？
//        print("self.steamID exists?: \(self.steamID)")
//        return self.steamID
//    }
//    
//    private func resolveVanityURL(_ customID: String)throws {
//        AF.request("https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/",
//                   method: .get,
//                   parameters: [
//                    "key" : steamKey,
//                    "vanityurl" : customID],
//                   encoding: URLEncoding(destination: .queryString)
//                   
//        ).response { response in
//            switch response.result {
//            case .success:
//                guard let data = response.data else {
//                   // throw AFError.responsetError
//                    print("ERROR: Error with response")
//                    return
//                }
//                
//                do {
//                    
//                    let decoder = JSONDecoder()
//                    let result: ResultVanity = try decoder.decode(ResultVanity.self, from: data)
//                    
//                    self.steamID = result.response.steamid
//                    print("steamID is: \(self.steamID) or \(result.response.steamid)")
//                    
//                    debugPrint("-----")
//                    debugPrint(result)
//                    debugPrint(self.steamID)
//                } catch {
//                   // throw AFError.parseError
//                    print("ERROR: failed to parse JSON: \(error)")
//                }
//                
//            case .failure(let error):
//                print("ERROR: \(error)")
//            }
//        }
//        
//    }
//    
//    private func getPlayerSummary(_ steamID: String) {
//        AF.request("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/",
//                   method: .get,
//                   parameters: [
//                    "key" : steamKey,
//                    "steamids" : steamID],
//                   encoding: URLEncoding(destination: .queryString)
//                   
//        ).response { response in
//            switch response.result {
//            case .success:
//                guard let data = response.data else {
//                    print("ERROR: Error with response")
//                    return
//                }
//                
//                do {
//                    let decoder = JSONDecoder()
//                    let result = try decoder.decode(ResultPlayer.self, from: data)
//                    //self.steamID = result.response.players.personaname
//                    //result.response.players.avatarfull
//                    //result.response.players.steamid
//                 
//           
//                    debugPrint(result)
//                } catch {
//                    print("ERROR: failed to parse JSON: \(error)")
//                }
//                
//            case .failure(let error):
//                print("ERROR: \(error)")
//            }
//        }
//    }
//}
