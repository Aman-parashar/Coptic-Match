import UIKit
import SDWebImage

class ImageMsgTblCell: UITableViewCell {
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgBubble: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMessage.layer.cornerRadius = 8
        imgMessage.clipsToBounds = true
        imgBubble.alpha = 0
    }
    
    func configure(with url: String, isOutgoing: Bool) {
        imgMessage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
        
        if isOutgoing {
            bgView.backgroundColor = UIColor(hex: "#266FA8")
            imgBubble.image = UIImage(named: "outgoing-message-bubble")?
                .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
            imgBubble.tintColor = UIColor(hex: "#266FA8")
        } else {
            bgView.backgroundColor = .systemGray5
            imgBubble.image = UIImage(named: "incoming-message-bubble")?
                .resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
        }
    }
}
