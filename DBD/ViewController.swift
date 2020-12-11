import UIKit
import Alamofire

class ViewController: UIViewController {
    
    // MARK: Properties
    var list: [String] = []
    var headerText: String = ""
    var steamID: String = ""
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tapSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
            print(searchWord)
            
            /* APIリクエスト */
            let req = RequestSteamAPI(input: searchWord)
            /* バリデーション */
            do {
                //try req.validate()
                try headerText = req.validate()
                print("headerText exists?: \(headerText)")
                tableView.reloadData()
                return
            } catch {
                // エラーが来たら
                headerText = "正しい値を入力してください"
                print("正しい値を入力してください")
                tableView.reloadData()
                return
            }
        
        }
    }
}



// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 //test
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     // 表示のための、cellオブジェクト(一行)を取得する
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
        headerCell.textLabel?.text = headerText

        return headerCell
    }
}
 
     
 // MARK: UITableViewDelegate
 extension ViewController: UITableViewDelegate {
    // タップされたら、アラートを表示する
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
     }
 }
