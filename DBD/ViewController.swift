import UIKit
import Alamofire
import Nuke
import MBProgressHUD
import SwiftUI

class ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func selectButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableList.removeAll()
            tableList = allStatsList
            //statsNameTableList = survStatsList
            //statsValueTableList = allStatsList
            print("0")
        case 1:
            tableList.removeAll()
            tableList = survStatsList
           // playerStatsNameTable = survStatsList
           // playerStatsValueTable = killerStatsList
            print("1")
        case 2:
            tableList.removeAll()
            tableList = killerStatsList
           // playerStatsNameTable = ["A","B"]
           // playerStatsValueTable = allStatsList
            print("2")
        default:
            break
        }
        tableView.reloadData()
    }

    
    // steamAPIアクセス用のkey
    let steamKey = "A96399B2B4BD19AF214EBD58F6BF2689"
    // ゲームID
    let dbd = "381210"
    
    var validationErrorText: String = ""
    var steamID: String = ""
    
    let avatarFull = "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/e3/e3dcfb9bf6eaf721587f69aa1bdb825807e11d63_full.jpg"
    
//    /* debugカテゴリ別データ*/
//    let allStatsList = [1,2.2,3]
//    let survStatsList = ["a","b","c"]
//    let killerStatsList = [0,9.0,8]
//
    /* 表示用の配列*/
    var tableList: [(name: String, value: String)] = []
    
    /* データ格納用の配列 */
    var allStatsList: [(name: String, value: String)] = []
    var survStatsList: [(name: String, value: String)] = []
    var killerStatsList: [(name: String, value: String)] = []
    
    //var statsNameTableList: [String] = []
    //var statsValueTableList: [Double] = []
    var detailName = ""
    var detailValue = ""
    
    /* indicator */
    var hud = MBProgressHUD()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* debug用 */
        //Nuke.loadImage(with: URL(string: avatarFull)!, into: playerImage)
        //playerName.text = "MyName"
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        let playerStatsTableNib = UINib(nibName: "PlayerStatsTableViewCell", bundle: nil)
        tableView.register(playerStatsTableNib, forCellReuseIdentifier: "PlayerStatsCell")
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: Methods
    func showErrorAlert() {
        let errorAlert = UIAlertController(title: "エラー", message: "正しい値を入力してください", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(errorAlert, animated: true, completion: nil)
    }
}


// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if var searchWord = searchBar.text {
            print("searchWord is:\(searchWord)")
            /* debug */
            //searchWord = "aaaa"
            
            /* バリデーション */
            do {
                try validateIDs(searchWord)
            } catch {
                showErrorAlert()
                print("ERROR:正しい値を入力してください")
                return
            }
            
            /* 注意！コールバック地獄！*/
            
            // HUDの表示開始
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Searching..."
            
            // MARK: ResolveVanityURL
            /* 入力がCustomIDであった場合にSteamIDに変換 */
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
                        self.showErrorAlert()
                        print("ERROR: Error with response")
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let result: ResultVanity = try decoder.decode(ResultVanity.self, from: data)
                        
                        /* set steamID */
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
                                    self.showErrorAlert()
                                    print("ERROR: Error with response")
                                    return
                                }
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResultStats.self, from: data)
                                    
                                    // setGameStats(result)
                                    /* func setGameStats(_ result: ResultStats) -> [(Stats)] */
                                    // 引数 result:ResultStats型
                                    // 配列に格納
                                 
                                    // リストを初期化
                                    self.tableList.removeAll()
                                    self.allStatsList.removeAll()
                        
                                    for stat in result.playerstats.stats {
                                        
                                        // getLocalizedName(stat: Stat, lang: String)
                                        /* func setLocalizedName(stat stat: Stats, lang language: String) -> */
                                        
                                        // lang = "JA"
                                        /* stat.name を switch文で日本語に*/
                                        
                                        
                                        var localName = ""
                                        var category = ""
                                        
                                        switch stat.name {
                                        case "DBD_KillerSkulls":
                                            localName = "キラーランク"
                                            category = "Killer"
                                            self.killerStatsList.append((name: localName, value: String(format: "%.0f", stat.value)))
                                        case "DBD_CamperSkulls":
                                            localName = "サバイバーランク"
                                            category = "Survivor"
                                            self.survStatsList.append((name: localName, value: String(format: "%.0f", stat.value)))
                                        default:
                                            print("none")
                                            category = "All"
                                            self.allStatsList.append((name: stat.name/*localName*/, value: String(format: "%.0f", stat.value)))
                                        }
                                        
                                        /* setValue */
                                        /* stat.value を　小数点以下２位まで表示に */
                                        
                                        /* switch case name==all killer surv配列
                                            self.showAll survtable killerTable */
//                                        // debug
//
//                                        gameStats = Stats(name: "surv", value: 1.1)//debug
//                                        self.survStatsList.append(gameStats)
//
//                                        gameStats = Stats(name: "killer", value: 1.2)//debug
//                                        self.killerStatsList.append(gameStats)
                                    }
                                    // debug
                                    if let firstTable = self.tableList.first {
                                        print("tableList[0] = \(firstTable)")
                                    }
                                    
                                    /* close - setGameStats */
                                    self.tableList = self.allStatsList
                                    self.tableView.reloadData()
                    
                                    //debugPrint(result)
                                    print(result.playerstats.steamID)
                                    print("count: \(result.playerstats.stats.count)")
                                    print(result.playerstats.stats[0].value)
                                    print("--statsForGame 1--")
                                    
                                    // MARK: 1 - getPlayerSummaries(Success)
                                    AF.request("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/",
                                               method: .get,
                                               parameters: [
                                                "key" : self.steamKey,
                                                "steamids" : result.playerstats.steamID],
                                               encoding: URLEncoding(destination: .queryString)
                                               
                                    ).response { response in
                                        switch response.result {
                                        case .success:
                                            guard let data = response.data else {
                                                self.showErrorAlert()
                                                print("ERROR: Error with response")
                                                return
                                            }
                                            
                                            do {
                                                let decoder = JSONDecoder()
                                                let result: ResultPlayer = try decoder.decode(ResultPlayer.self, from: data)
                                                
                                                /* setPlayerSummaries */
                                                self.playerName.text = result.response.players[0].personaname
                                                
                                                let imageURL = result.response.players[0].avatarfull
                                                Nuke.loadImage(with: imageURL, into: self.playerImage)
                                                /* close */
                                              
                                                
                                                debugPrint(result)
                                                print(result.response.players[0].personaname)
                                                print(result.response.players[0].avatarfull)
                                                print("--playerSummaries 1--")
                                                
                                            }catch {
                                                self.showErrorAlert()
                                                print("ERROR: Error with response")
                                                return
                                            }
                                        case .failure(let error):
                                            self.showErrorAlert()
                                            print("ERROR: \(error)")
                                            return
                                        }
                                    }
                                    /* close 1 - getUserStatsForGame */
                                } catch {
                                    self.showErrorAlert()
                                    print("ERROR: Error with response")
                                    return
                                }
                            case .failure(let error):
                                self.showErrorAlert()
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
                                    self.showErrorAlert()
                                    print("ERROR: Error with response")
                                    return
                                }
                                do {
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(ResultStats.self, from: data)
                                    debugPrint(result)
                                    print(result.playerstats.steamID)
                                    print(result.playerstats.stats[0].name)
                                    print(result.playerstats.stats[0].value)
                                    print("--gameStats 2--")
                                    
                                    
                                    // MARK: 2 - getPlayerSummaries(Error)
                                    AF.request("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/",
                                               method: .get,
                                               parameters: [
                                                "key" : self.steamKey,
                                                "steamids" : result.playerstats.steamID],
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
                                                
                                                /* setPlayerSummaries */
                                                self.playerName.text = result.response.players[0].personaname
                                                
                                                let imageURL = result.response.players[0].avatarfull
                                                Nuke.loadImage(with: imageURL, into: self.playerImage)
                                                
                                                debugPrint(result)
                                                print(result.response.players[0].personaname)
                                                print(result.response.players[0].avatarfull)
                                                print("-- playerSummaries 2--")
                                                
                                            }catch {
                                                self.showErrorAlert()
                                                print("ERROR: Error with response")
                                                return
                                            }
                                        case .failure(let error):
                                            self.showErrorAlert()
                                            print("ERROR: \(error)")
                                            return
                                        }
                                    }
                                    /* close - getUserStats */
                                } catch {
                                    self.showErrorAlert()
                                    print("ERROR: Error with response")
                                    return
                                }
                            case .failure(let error):
                                self.showErrorAlert()
                                print("ERROR: \(error)")
                                return
                            }
                        }
                        /* close - getPlayerSummaries */
                        
                    }
                case .failure(let error):
                    self.showErrorAlert()
                    print("ERROR: \(error)")
                    return
                }
                
                // HUDの非表示
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            /* close - resultVanity */
            
            print("Done Task")
            tableView.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count//statsNameTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let playerStatsCell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatsCell", for: indexPath) as? PlayerStatsTableViewCell else {
            return UITableViewCell()
        }
        
        playerStatsCell.set(key: tableList[indexPath.row].name, value: String(tableList[indexPath.row].value))
        
        return playerStatsCell
    }
}


// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        detailName = tableList[indexPath.row].name
        detailValue = tableList[indexPath.row].value
    
        performSegue(withIdentifier: "showDetailStats", sender: tableView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "showDetailStats") {
            let viewController: DetailStatsViewController = (segue.destination as? DetailStatsViewController)!
            
            viewController.name = detailName
            viewController.value = detailValue
        }
    }
}
