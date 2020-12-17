
import UIKit

class DetailStatsViewController: UIViewController {
    var name = ""
    var value = ""
    
    @IBOutlet weak var detailname: UILabel!
    @IBOutlet weak var detailvalue: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        detailname.text = name
        detailvalue.text = value
    }

}
