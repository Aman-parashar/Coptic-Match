//
//  CustomAlertView.swift
//  HalalDating
//
//  Created by Apple on 29/11/24.
//

import UIKit
import Alamofire


class CustomAlertView: UIView {
    // Create a custom alert view that can be added as a subview
    convenience init(title: String, message: String) {
        self.init(frame: CGRect.zero)
        setupView(title: title, message: message)
    }
    
    private func setupView(title: String, message: String) {
        // Create a container view
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Message label
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Rate Now button
        let rateButton = UIButton(type: .system)
        rateButton.setTitle("Rate Now", for: .normal)
        rateButton.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
        rateButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Cancel button
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(rateButton)
        containerView.addSubview(cancelButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            rateButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            rateButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rateButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor),
            rateButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            containerView.bottomAnchor.constraint(equalTo: rateButton.bottomAnchor, constant: 20)
        ])
        
        // Background view to dim the background
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func rateButtonTapped() {
        // Implement rate logic
        setRating {
            if let url = URL(string: "https://apps.apple.com/app/id6477770277?action=write-review"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        removeFromSuperview()
    }
    
    @objc private func cancelButtonTapped() {
        removeFromSuperview()
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add animation
        alpha = 0
        transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}

func setRating(completion: @escaping () -> Void) {
    let userModel = Login_LocalDB.getLoginUserModel()
    
    let headers: HTTPHeaders = ["Accept": "application/json",
                                "Authorization": userModel.data?.api_token ?? ""]
    
    AF.request(set_rating, method: .post, parameters: ["play_store_review": 1], headers: headers).responseJSON { response in
        switch response.result {
        case .success(let data):
            if let json = data as? [String: Any] {
                print("Response JSON: \(json)")
                
                if let data = json["data"] as? [String: Any],
                   let playStoreReview = data["play_store_review"] as? Int {
                    
                    print("Play Store Review: \(playStoreReview)")
                    completion()
                }
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            completion()
        }
    }
}
