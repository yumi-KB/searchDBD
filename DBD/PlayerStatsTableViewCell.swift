import UIKit

class PlayerStatsTableViewCell: UITableViewCell {
    @IBOutlet weak var playerStatsKeyLabel: UILabel!
    @IBOutlet weak var playerStatsValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(key: String, value: String) {
        playerStatsKeyLabel.text = key
        playerStatsValueLabel.text = value
    }
}
