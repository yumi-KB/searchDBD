// TODO: error: nw_protocol_get_quic_image_block_invoke dlopen libquic failed

import UIKit
import Alamofire
import Nuke
import MBProgressHUD

class SearchStatsViewController: UIViewController {
    
    // MARK: IB Properties/Action
    
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
            print("0")
            
        case 1:
            tableList.removeAll()
            tableList = survStatsList
            print("1")
            
        case 2:
            tableList.removeAll()
            tableList = killerStatsList
            print("2")
            
        default:
            break
        }
        tableView.reloadData()
    }
    
    // MARK: Properties
    
    // steamAPIアクセス用のkey
    let steamKey = "A96399B2B4BD19AF214EBD58F6BF2689"
    // ゲームID
    let DBDID = "381210"
    
    /* 表示用の配列*/
    var tableList: [(name: String, value: String, key: String)] = []
    
    /* データ格納用の配列 */
    var allStatsList: [(name: String, value: String, key: String)] = []
    var survStatsList: [(name: String, value: String, key: String)] = []
    var killerStatsList: [(name: String, value: String, key: String)] = []
    
    /* DetailStatsViewControllerに渡す変数 */
    var detailName = ""
    var detailValue = ""
    var steamID = ""
    var statKey = ""
    
    /* indicator */
    var hud = MBProgressHUD()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func setPlayerSummaries(name: String , imageURL: URL) {
        self.playerName.text = name
        Nuke.loadImage(with: imageURL, into: self.playerImage)
    }
    
    private func setStatsLists(name: String, value: String, category: String, key: String) {
        switch category {
        case "All":
            self.allStatsList.append((name: name, value: value, key: key))
        case "Survivor":
            self.survStatsList.append((name: name, value: value, key: key))
        case "Killer":
            self.killerStatsList.append((name: name, value: value, key: key))
        default:
            break
        }
    }
    
    private func resolveVanityURL(input: String, completion: @escaping() -> Void) {
        /* 入力がCustomIDであった場合にSteamIDに変換 */
        AF.request("https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/",
                   method: .get,
                   parameters: [
                    "key" : self.steamKey,
                    "vanityurl" : input],
                   encoding: URLEncoding(destination: .queryString)
                   
        ).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    self.showErrorAlert()
                    print("[ResultVanityURL] ERROR: Error with response")
                    return
                }
                defer {
                    print("[ResultVanityURL] result: \(self.steamID)")
                    completion()
                }
                do {
                    let decoder = JSONDecoder()
                    let result: ResultVanity = try decoder.decode(ResultVanity.self, from: data)
                    /* set steamID */
                    self.steamID = result.response.steamid
                    
                } catch {
                    print("ERROR: failed to parse JSON: \(error)")
                    /* set steamID: steamIDと仮定し次のメソッドに検索をかける */
                    self.steamID = input
                }
                
            case .failure(let error):
                self.showErrorAlert()
                print("[ResultVanityURL] ERROR: \(error)")
                return
            }
        }
    }   /* close - resolveVanity */
    
    private func getUserStatsForGame(steamID: String, completion: @escaping(ResultStats) -> Void) {
        AF.request("https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/",
                   method: .get,
                   parameters: [
                    "key" : self.steamKey,
                    "steamid" : steamID,
                    "appid" : self.DBDID],
                   encoding: URLEncoding(destination: .queryString)
                   
        ).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    self.showErrorAlert()
                    print("[getUserStatsForGame] ERROR: Error with response")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ResultStats.self, from: data)
                    completion(result)
                    
                    // リストを初期化
                    self.tableList.removeAll()
                    self.allStatsList.removeAll()
                    self.survStatsList.removeAll()
                    self.killerStatsList.removeAll()
                    
                    /* set */
                    for stat in result.playerstats.stats {
                        
                        let lang = "JP"
                        let localName = getLocalizedStatName(stat: stat, lang: lang)
                        let formattedValue = String(format: "%.0f", stat.value)
                        let category = getStatCategory(stat: stat)
                        
                        self.setStatsLists(name: localName, value: formattedValue, category: category, key: stat.name)
                    }
                    
                    /* tableViewの更新 */
                    self.segmentedControl.selectedSegmentIndex = 0
                    self.tableList = self.allStatsList
                    self.tableView.reloadData()
                    
                    // debugPrint(result)
                    print("steamID: \(result.playerstats.steamID)")
                    print("number of stats: \(result.playerstats.stats.count)")
                    print("[0].name: \(result.playerstats.stats[0].name) [0].value: \(result.playerstats.stats[0].value)")
                    print("-- getUserStatsForGame Done --")
                    
                } catch {
                    self.showErrorAlert()
                    print("[getUserStatsForGame] ERROR: Error with response")
                    return
                }
                
            case .failure(let error):
                self.showErrorAlert()
                print("[getUserStatsForGame] ERROR: \(error)")
                return
            }
        }
    }   /* close - getUserStatsForGame */
    
    private func getPlayerSummaries(steamID: String) {
        AF.request("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/",
                   method: .get,
                   parameters: [
                    "key" : self.steamKey,
                    "steamids" : steamID /* result.playerstats.steamID */],
                   encoding: URLEncoding(destination: .queryString)
                   
        ).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    self.showErrorAlert()
                    print("[getPlayerSummaries] ERROR: Error with response")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result: ResultPlayer = try decoder.decode(ResultPlayer.self, from: data)
                    
                    /* set */
                    let name = result.response.players[0].personaname
                    let image = result.response.players[0].avatarfull
                    self.setPlayerSummaries(name: name, imageURL: image)
                    
                    //debugPrint(result)
                    print("name: \(result.response.players[0].personaname)")
                    print("imageURL: \(result.response.players[0].avatarfull)")
                    print("-- playerSummaries Done --")
                    
                }catch {
                    self.showErrorAlert()
                    print("[getPlayerSummaries] ERROR: Error with response")
                    return
                }
                
            case .failure(let error):
                self.showErrorAlert()
                print("[getPlayerSummaries] ERROR: \(error)")
                return
            }
        }
    }   /* close - getPlayerSummaries */
    
}


// MARK: - UISearchBarDelegate
extension SearchStatsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
            print("searchWord: \(searchWord)")
            
            /* バリデーション */
            do {
                try validateIDs(searchWord)
            } catch {
                showErrorAlert()
                print("ERROR: 正しい値を入力してください")
                return
            }
            
            /* HUDの表示開始 */
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Searching..."
            
            /* request API */
            resolveVanityURL(input: searchWord, completion: {
                self.getUserStatsForGame(steamID: self.steamID, completion: {_ in
                    self.getPlayerSummaries(steamID: self.steamID)
                })
                /* HUDの表示終了 */
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
}


// MARK: - UITableViewDataSource
extension SearchStatsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
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
extension SearchStatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        detailName = tableList[indexPath.row].name
        detailValue = tableList[indexPath.row].value
        statKey = tableList[indexPath.row].key
        
        performSegue(withIdentifier: "showDetailStats", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "showDetailStats") {
            let viewController: DetailStatsViewController = (segue.destination as? DetailStatsViewController)!
            
            viewController.statName = detailName
            viewController.statValue = detailValue
            
            viewController.steamID = steamID
            viewController.statKey = statKey
        }
    }
}
