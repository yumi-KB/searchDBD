import UIKit
import Alamofire
import Nuke

class ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func selectButton(_ sender: UISegmentedControl) {
        //        switch sender.selectedSegmentIndex {
        //        case 0:
        //            break;
        //        case 1:
        //            break;
        //        case 2:
        //            break;
        //        default:
        //            break
        //        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    // steamAPIアクセス用のkey
    let steamKey = "A96399B2B4BD19AF214EBD58F6BF2689"
    // ゲームID
    let dbd = "381210"
    
    var validationErrorText: String = ""
    var steamID: String = ""
    
    let avatarFull = "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/e3/e3dcfb9bf6eaf721587f69aa1bdb825807e11d63_full.jpg"
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Nuke.loadImage(with: URL(string: avatarFull)!, into: playerImage)
        playerName.text = "MyName"
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        let playerStatsTableNib = UINib(nibName: "PlayerStatsTableViewCell", bundle: nil)
        tableView.register(playerStatsTableNib, forCellReuseIdentifier: "PlayerStatsCell")
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if var searchWord = searchBar.text {
            print("searchWord is:\(searchWord)")
            /* debug */
            searchWord = "76561198193960305"
            
            /* バリデーション */
            do {
                try validateIDs(searchWord)
            } catch {
                validationErrorText = "正しい値を入力してください"
                print("ERROR:正しい値を入力してください")
                // tableView.reloadData()
                return
            }
            
            /* 注意！コールバック地獄！*/
            // MARK: ResolveVanityURL
            AF.request("https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/",
                       method: .get,
                       parameters: [
                        "key" : steamKey,
                        "vanityurl" : searchWord],
                       encoding: URLEncoding(destination: .queryString)
                       
            ).response { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        print("ERROR: Error with response")
                        return
                    }
                    do {
                        /* 入力がCustomIDであった場合にSteamIDに変換 */
                        let decoder = JSONDecoder()
                        let result: ResultVanity = try decoder.decode(ResultVanity.self, from: data)
                        
                        self.steamID = result.response.steamid
                        
                        debugPrint(result)
                        debugPrint(self.steamID)
                        debugPrint("--ResultVanityURL--")
                        
                        
                        // MARK: 1 - getUserStatsForGame(Success)
                        AF.request("https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/",
                                   method: .get,
                                   parameters: [
                                    "key" : self.steamKey,
                                    "steamid" : self.steamID,
                                    "appid" : self.dbd],
                                   encoding: URLEncoding(destination: .queryString)
                                   
                        ).response { response in
                            switch response.result {
                            case .success:
                                guard let data = response.data else {
                                    print("ERROR: Error with response")
                                    return
                                }
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResultStats.self, from: data)
                                    debugPrint(result)
                                    print("--statsForGame 1--")
                                    
                                    // MARK: 1 - getPlayerSummaries(Success)
                                    AF.request("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/",
                                               method: .get,
                                               parameters: [
                                                "key" : self.steamKey,
                                                "steamids" : self.steamID],
                                               encoding: URLEncoding(destination: .queryString)
                                               
                                    ).response { response in
                                        switch response.result {
                                        case .success:
                                            guard let data = response.data else {
                                                print("ERROR: Error with response")
                                                return
                                            }
                                            
                                            do {
                                                let decoder = JSONDecoder()
                                                let result: ResultPlayer = try decoder.decode(ResultPlayer.self, from: data)
                                                //  self.userName = result.response.players.personaname
                                                // userImage = result.response.players.avatarfull
                                                //result.response.players.steamid
                                                debugPrint(result)
                                                print("--playerSummaries 1--")
                                                
                                            }catch {
                                                
                                                print("ERROR: Error with response")
                                                return
                                            }
                                        case .failure(let error):
                                            print("ERROR: \(error)")
                                            return
                                        }
                                    }
                                    /* close 1 - getUserStatsForGame */
                                } catch {
                                    print("ERROR: Error with response")
                                    return
                                }
                            case .failure(let error):
                                print("ERROR: \(error)")
                                return
                            }
                        }
                        /* close 1 - getPlayerSummaries */
                        
                        
                        /* 2 */
                    } catch {
                        /* 入力がCustomIDでない場合 数字のみの値であればSteamIDとして扱う */
                        print("ERROR: failed to parse JSON: \(error)")
                        
                        self.steamID = searchWord
                        debugPrint(self.steamID)
                        debugPrint("-----")
                        
                        // MARK: 2 - getUserStatsForGame(Error)
                        AF.request("https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/",
                                   method: .get,
                                   parameters: [
                                    "key" : self.steamKey,
                                    "steamid" : self.steamID,
                                    "appid" : self.dbd],
                                   encoding: URLEncoding(destination: .queryString)
                                   
                        ).response { response in
                            switch response.result {
                            case .success:
                                guard let data = response.data else {
                                    print("ERROR: Error with response")
                                    return
                                }
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResultStats.self, from: data)
                                    debugPrint(result)
                                    print("--gameStats 2--")
                                    
                                    
                                    // MARK: 2 - getPlayerSummaries(Error)
                                    AF.request("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/",
                                               method: .get,
                                               parameters: [
                                                "key" : self.steamKey,
                                                "steamids" : self.steamID],
                                               encoding: URLEncoding(destination: .queryString)
                                               
                                    ).response { response in
                                        switch response.result {
                                        case .success:
                                            guard let data = response.data else {
                                                print("ERROR: Error with response")
                                                return
                                            }
                                            
                                            do {
                                                let decoder = JSONDecoder()
                                                let result = try decoder.decode(ResultPlayer.self, from: data)
                                                //self.steamID = result.response.players.personaname
                                                //result.response.players.avatarfull
                                                //result.response.players.steamid
                                                debugPrint(result)
                                                print("-- playerStats 2--")
                                                
                                            }catch {
                                                
                                                print("ERROR: Error with response")
                                                return
                                            }
                                        case .failure(let error):
                                            print("ERROR: \(error)")
                                            return
                                        }
                                    }
                                    /* close - getUserStats */
                                } catch {
                                    print("ERROR: Error with response")
                                    return
                                }
                            case .failure(let error):
                                print("ERROR: \(error)")
                                return
                            }
                        }
                        /* close - getPlayerSummaries */
                        
                    }
                case .failure(let error):
                    print("ERROR: \(error)")
                    return
                }
            }
            /* close - resultVanity */
            
            print("Done Task")
        }
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let playerStatsCell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatsCell", for: indexPath) as? PlayerStatsTableViewCell else {
            return UITableViewCell()
        }
        
        playerStatsCell.set(key: "データ", value: "1011.11")
        
        return playerStatsCell
    }
}


// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    // タップされたら、アラートを表示する
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
