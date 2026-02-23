//
//  HeaderView.swift
//  Melo
//
//  Created by Maulik Vora on 07/02/21.
//

import UIKit

@objc public protocol HeaderView_Protocol : NSObjectProtocol{
    @objc optional func btnBack()
    
}

class HeaderView: UIView {
    
    //MARK:- IBOutlet
    @IBOutlet weak var viewbg_back: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var imgAppIcon: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    
    
    
    //MARK:- Veriable
    let nibName = "HeaderView"
    var contentView: UIView?
    weak var delegate_HeaderView : HeaderView_Protocol? = nil
    
    
    
    override func awakeFromNib() {
        
        if Helper.shared.strLanguage == "ar" {
            viewbg_back.semanticContentAttribute = .forceRightToLeft
            progressBar.semanticContentAttribute = .forceRightToLeft
            imgBack.semanticContentAttribute = .forceRightToLeft
        }

    }
    
    
    //MARK:- func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    
    //MARK:- IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.delegate_HeaderView?.btnBack?()
    }
    
    
    
    
    
}
