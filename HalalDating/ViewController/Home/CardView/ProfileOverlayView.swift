//
//  ProfileOverlayView.swift
//  HalalDating
//
//  Created by Apple on 18/09/24.
//

import Foundation
import Koloda
import SDWebImage

class ProfileOverlayView: OverlayView, UIScrollViewDelegate {
    
    //MARK: - Variables
    var userData: UserData! {
        didSet {
            setData()
        }
    }
    
//    var arrIcons: [String] = ["iconHeart", "iconKid", "iconSearch", "iconEducation", "iconHeight", "iconPlayer", "iconReligion", "iconStar"]
    var arrIcons: [String] = ["ic_maritial_status", "ic_kids", "ic_education", "ic_looking_for", "ic_height", "ic_religious", "ic_denomination", "ic_star"]
    var arrMyLifestyleIcons = ["ic_pray", "ic_church", "ic_smoke", "ic_workout", "ic_drink"]

    
    var arrAbout: [String] = []
    var arrLanguage: [String] = []
    var arrLifestyle: [String] = []
    var arrMarriageGoal: [String] = []
    var arrImages: [String] = []
    
    var btnCancelAction: (() -> ())?
    var btnCommentAction: (() -> ())?
    var btnLikeAction: (() -> ())?
    var btnReportAction: (() -> ())?
    var btnBlockAction: (() -> ())?
    
    var didScroll: ((_ contentOffset: CGFloat) -> ())?

    
    //MARK: - @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var abountMeCollView: UICollectionView!
    @IBOutlet weak var languageCollView: UICollectionView!
    @IBOutlet weak var imagesCollView: UICollectionView!
    @IBOutlet weak var imageCollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imagesTableView: UITableView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var myLifestyleCollView: UICollectionView!
    @IBOutlet weak var marrigeGoalCollView: UICollectionView!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var mainImageView: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imgOverlayTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var aboutMeCollHeight: NSLayoutConstraint!
    @IBOutlet weak var languageCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var myLifestyleCollHeight: NSLayoutConstraint!
    @IBOutlet weak var imageTableHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblLookingFor: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnBlock: UIButton!
    
    @IBOutlet lazy var overlayImageView: UIImageView! = { [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        return imageView
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let window = UIApplication.shared.windows.first {
            let topSafeArea = window.safeAreaInsets.top
            imgOverlayTopConstraint.constant = -topSafeArea
        } else {
            imgOverlayTopConstraint.constant = Helper.shared.isSmallDevice() ? -20 : -60
        }
        
        
        abountMeCollView.backgroundColor = .clear
        abountMeCollView.delegate = self
        abountMeCollView.dataSource = self
        abountMeCollView.register(UINib(nibName: TagListCell.className, bundle: nil), forCellWithReuseIdentifier: TagListCell.className)

        languageCollView.backgroundColor = .clear
        languageCollView.delegate = self
        languageCollView.dataSource = self
        languageCollView.register(UINib(nibName: TagListCell.className, bundle: nil), forCellWithReuseIdentifier: TagListCell.className)

//        imagesCollView.backgroundColor = .clear
//        imagesCollView.delegate = self
//        imagesCollView.dataSource = self
//        imagesCollView.register(UINib(nibName: ImageCell.className, bundle: nil), forCellWithReuseIdentifier: ImageCell.className)
//        imagesCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        myLifestyleCollView.backgroundColor = .clear
        myLifestyleCollView.delegate = self
        myLifestyleCollView.dataSource = self
        myLifestyleCollView.register(UINib(nibName: TagListCell.className, bundle: nil), forCellWithReuseIdentifier: TagListCell.className)

        marrigeGoalCollView.backgroundColor = .clear
        marrigeGoalCollView.delegate = self
        marrigeGoalCollView.dataSource = self
        marrigeGoalCollView.register(UINib(nibName: TagListCell.className, bundle: nil), forCellWithReuseIdentifier: TagListCell.className)
        
        imagesTableView.backgroundColor = .clear
        imagesTableView.delegate = self
        imagesTableView.dataSource = self
        imagesTableView.register(UINib(nibName: ImageTableCell.className, bundle: nil), forCellReuseIdentifier: ImageTableCell.className)

        
        
        if let _ = abountMeCollView.collectionViewLayout as? UICollectionViewFlowLayout {
            let rightAlignedLayout = LeftAlignedFlowLayout()
            rightAlignedLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // Enable automatic sizing
            rightAlignedLayout.minimumInteritemSpacing = 8  // Adjust for your desired spacing
            rightAlignedLayout.minimumLineSpacing = 8
            abountMeCollView.setCollectionViewLayout(rightAlignedLayout, animated: false)
        }

        if let layout = languageCollView.collectionViewLayout as? UICollectionViewFlowLayout {
            let rightAlignedLayout = LeftAlignedFlowLayout()
            rightAlignedLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // Enable automatic sizing
            rightAlignedLayout.minimumInteritemSpacing = 8  // Adjust for your desired spacing
            rightAlignedLayout.minimumLineSpacing = 8
//            rightAlignedLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            languageCollView.setCollectionViewLayout(rightAlignedLayout, animated: false)
        }

        if let layout = myLifestyleCollView.collectionViewLayout as? UICollectionViewFlowLayout {
            let rightAlignedLayout = LeftAlignedFlowLayout()
            rightAlignedLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // Enable automatic sizing
            rightAlignedLayout.minimumInteritemSpacing = 8  // Adjust for your desired spacing
            rightAlignedLayout.minimumLineSpacing = 8
//            rightAlignedLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            myLifestyleCollView.setCollectionViewLayout(rightAlignedLayout, animated: false)
        }

        if let layout = marrigeGoalCollView.collectionViewLayout as? UICollectionViewFlowLayout {
            let rightAlignedLayout = LeftAlignedFlowLayout()
            rightAlignedLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // Enable automatic sizing
            rightAlignedLayout.minimumInteritemSpacing = 8  // Adjust for your desired spacing
            rightAlignedLayout.minimumLineSpacing = 8
//            rightAlignedLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            marrigeGoalCollView.setCollectionViewLayout(rightAlignedLayout, animated: false)
        }

        
        btnCancel.addTarget(self, action: #selector(btnCancelTapped), for: .touchUpInside)
        btnComment.addTarget(self, action: #selector(btnCommentTapped), for: .touchUpInside)
        btnLike.addTarget(self, action: #selector(btnLikeTapped), for: .touchUpInside)
        btnReport.addTarget(self, action: #selector(btnReportTapped), for: .touchUpInside)
        btnBlock.addTarget(self, action: #selector(btnBlockTapped), for: .touchUpInside)
        
        scrollview.delegate = self
    }
    
        
    override func layoutSubviews() {
        super.layoutSubviews()

        DispatchQueue.main.async {
            self.aboutMeCollHeight.constant = self.abountMeCollView.collectionViewLayout.collectionViewContentSize.height
            self.languageCollectionHeight.constant = self.languageCollView.collectionViewLayout.collectionViewContentSize.height
            self.myLifestyleCollHeight.constant = self.myLifestyleCollView.collectionViewLayout.collectionViewContentSize.height
            self.layoutIfNeeded()
        }
    }
    
    @objc func btnCancelTapped() {
        btnCancelAction?()
    }
    
    @objc func btnCommentTapped() {
        btnCommentAction?()
    }
    
    @objc func btnLikeTapped() {
        btnLikeAction?()
    }
    
    @objc func btnReportTapped() {
        btnReportAction?()
    }
    
    @objc func btnBlockTapped() {
        btnBlockAction?()
    }
    
    
    func setData() {
        lblTitle.text = "\(userData.name), \(userData.age)"
        lblAddress.text = "\(userData.city), \(userData.country)"
        lblDetail.text = ((userData.denomination_id).replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: "")
        lblLookingFor.text = userData.looking_for
        
        let imgName = "\(kImageBaseURL)\(userData.user_image.first?.image ?? "")".replacingOccurrences(of: " ", with: "%20")
        
        ImageLoader().imageLoad(imgView: overlayImageView, url: imgName)

        if userData.user_image.count > 1 {
            let secondImage = "\(kImageBaseURL)\(userData.user_image[1].image)".replacingOccurrences(of: " ", with: "%20")
            ImageLoader().imageLoad(imgView: secondImageView, url: secondImage)
        }
        
        
        
        ///for about me section
        arrAbout.append(userData.relation_status)
//        arrAbout.append(userData.looking_for)
        arrAbout.append(userData.kids)
        arrAbout.append(userData.education)
        arrAbout.append(userData.looking_for)
        arrAbout.append(userData.height)
        arrAbout.append(userData.religious)
        arrAbout.append(((userData.denomination_id).replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))
//        if userData.your_zodiac != "" {
//            arrAbout.append(userData.your_zodiac)
//        } // Remove Zodiac
        abountMeCollView.reloadData()
        
        
        ///for language section
        var languages = ((userData.language_id).replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: "")
        arrLanguage = languages.components(separatedBy: ", ")
        languageCollView.reloadData()
        
        
        ///for my lifestyle section
        arrLifestyle.append(userData.pray)
        arrLifestyle.append(userData.go_church)
        arrLifestyle.append(userData.smoke)
        arrLifestyle.append(userData.work_out)
        arrLifestyle.append(userData.alcohol)
        myLifestyleCollView.reloadData()

        
        ///for my lifestyle section
        arrMarriageGoal.append(userData.married_year)
        marrigeGoalCollView.reloadData()

        
        ///for my image section
        for i in 0..<userData.user_image.count {
            if i > 1{
                arrImages.append("\(kImageBaseURL)\(userData.user_image[i].image)".replacingOccurrences(of: " ", with: "%20"))
            }
        }
        
//        imageTableHeight.constant = CGFloat(600 * arrImages.count + 20 + ((arrImages.count-1) * 10))
        imageTableHeight.constant = CGFloat(600 * arrImages.count + 20)
        imagesTableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
//        print("Scroll offset: \(contentOffset)")  // Log the scroll position
        
        didScroll?(contentOffset)
        // You can add conditions here based on scroll offset
//        if contentOffset ==  {
//            // Example: When scrolled beyond a certain point
//            lblTitle.textColor = .red // Change title color after scrolling beyond 200 points
//        } else {
//            lblTitle.textColor = .black // Reset title color
//        }
    }
    

}



//MARK: - UICollectionView methods -
extension ProfileOverlayView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case abountMeCollView: return arrAbout.count
        case languageCollView: return arrLanguage.count
        case myLifestyleCollView: return arrLifestyle.count
        case marrigeGoalCollView: return arrMarriageGoal.count
        default: return arrImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case abountMeCollView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListCell.className, for: indexPath) as? TagListCell else {
                return UICollectionViewCell()
            }
            
            
            cell.lblTitl.text = arrAbout[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            cell.ic_cat.image = UIImage(named: arrIcons[indexPath.row])
            return cell
            
            
        case languageCollView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListCell.className, for: indexPath) as? TagListCell else {
                return UICollectionViewCell()
            }
            
            cell.lblTitl.text = arrLanguage[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            cell.ic_cat.image = UIImage(named: "ic_language")
            return cell
            
            
        case myLifestyleCollView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListCell.className, for: indexPath) as? TagListCell else {
                return UICollectionViewCell()
            }
            
            cell.lblTitl.text = arrLifestyle[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            cell.ic_cat.image = UIImage(named: arrMyLifestyleIcons[indexPath.row])
            return cell
            
            
        case marrigeGoalCollView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListCell.className, for: indexPath) as? TagListCell else {
                return UICollectionViewCell()
            }
            
            cell.lblTitl.text = arrMarriageGoal[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            cell.ic_cat.image = UIImage(named: "ic_marriage_goal")
            return cell
            
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.className, for: indexPath) as? ImageCell else {
                return UICollectionViewCell()
            }
            cell.imageURLStr = arrImages[indexPath.row]
            return cell
        }
    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == imagesCollView {
//            // Full device width and fixed height of 600
//            return CGSize(width: UIScreen.main.bounds.width - 20, height: 600)
//        } else {
//            // Automatic size (e.g., flow layout handles it)
//            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                return flowLayout.itemSize
//            }
//            // Default size as fallback
//            return CGSize(width: 100, height: 100)
//        }
//    }

    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      
//        if collectionView == imagesCollView {
//            return CGSize(width: collectionView.frame.width, height: 600)
//            
//        } else {
//            
//            let text = arrAbout[indexPath.row]
//            let width = estimateFrameForText(text).width + 20  // Add padding
//            return CGSize(width: width, height: 55)
//        }
//    }
//
//    func estimateFrameForText(_ text: String) -> CGRect {
//        let size = CGSize(width: 2000, height: 55)
//        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
//        return NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
//    }
}





//MARK: - UITableview methods
extension ProfileOverlayView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableCell.className) as? ImageTableCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.imageURLStr = arrImages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        600
    }
}

