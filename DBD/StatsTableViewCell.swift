import UIKit

class StatsTableViewCell: UITableViewCell {
    @IBOutlet weak var statsName: UILabel!
    @IBOutlet weak var statsValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
