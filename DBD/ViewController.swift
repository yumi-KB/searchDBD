import UIKit
//import Alamofire

class ViewController: UIViewController {
    
    // MARK: Properties
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
         // searchPlayerInfo(key: searchWord)
        // segue
        }
    }
}


// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // お菓子のリストの総数
        return 0// okashiList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     // 表示のための、cellオブジェクト(一行)を取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsTableViewCell", for: indexPath)
     
     // お菓子のタイトル設定
        //statsName.text = "0"
        //statsValue.text = "1"
     // cell.textLabel?.text = okashiList[indexPath.row].name
     
     // お菓子画像を取得
//        if let userImage = try? Data(contentsOf: okashiList[indexPath.row].image) {
//            cell.imageView?.image = UIImage(data: userImage)
//        }
 
        return cell
    }
}
 
     
 // MARK: UITableViewDelegate, SFSafariViewControllerDelegate
 extension ViewController: UITableViewDelegate {
    // タップされたら、アラートを表示する
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         
         //let safariViewController = SFSafariViewController(url: okashiList[indexPath.row].link)
         //safariViewController.delegate = self
         
         //present(StatsDetailViewController, animated: true, completion: nil)
     }
     
//     func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//         dismiss(animated: true, completion: nil)
//     }
 }
