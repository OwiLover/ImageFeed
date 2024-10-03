//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/15/24.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private let tokenStorage = OAuthTokenStorage.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var avatarImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Profile was loaded!")
        guard let profile = profileService.profile else {
            return
        }
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
        
        updateAvatar()
    }
    
    private func addImageView(under someView: UIView?, image: UIImage?) -> UIImageView? {
        guard let someView else { return nil }
        
        let imageView: UIImageView = {
            let imageView = UIImageView(image: image ?? UIImage(systemName: "person.crop.circle.fill"))
            
            imageView.tintColor = .ypGray
            imageView.layer.cornerRadius = 35
            imageView.layer.masksToBounds = true
            
            return imageView
        }()
        
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: someView.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: someView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        return imageView
    }
    
    private func addButton(nextTo someView: UIView?, image: UIImage?, color: UIColor) -> UIButton? {
        guard let someView else { return nil }
        
        let button:UIButton = {
            let button = UIButton()
            
            button.setTitle(.none, for: .normal)
            button.setImage(image, for: .normal)
            button.tintColor = color
            return button
        }()
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.centerYAnchor.constraint(equalTo: someView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -14)
        ])
        
        return button
    }
    
    private func addLabel(under someView: UIView?, text: String?, font: UIFont, color: UIColor) -> UILabel? {
        guard let someView else { return nil }
        
        let label:UILabel = {
            let label = UILabel()
            
            label.text = text
            label.font = font
            label.textColor = color
            return label
        }()
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: someView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: someView.leadingAnchor)
        ])
        
        return label
    }
    
    private func updateProfileDetails(profile: Profile) {
        configureView(nameText: profile.name, tagText: profile.loginName, bioText: profile.bio)
    }
    
    private func configureView(nameText: String, tagText: String, bioText: String?) {
        view.backgroundColor = .ypBlack
        
        self.avatarImageView = addImageView(under: view, image: nil)
        _ = addButton(nextTo: avatarImageView, image: UIImage(named: "Exit"), color: .ypRed)
        let nameLabel = addLabel(under: avatarImageView, text: nameText, font: UIFont.systemFont(ofSize: 23, weight: .bold), color: .ypWhite)
        let tagLabel = addLabel(under: nameLabel, text: tagText, font: UIFont.systemFont(ofSize: 13), color: .ypGray)
        _ = addLabel(under: tagLabel, text: bioText, font: UIFont.systemFont(ofSize: 13), color: .ypWhite)
    }
    
    private func configureView() {
        view.backgroundColor = .ypBlack
        
        self.avatarImageView = addImageView(under: view, image: UIImage(named: "Photo"))
        _ = addButton(nextTo: avatarImageView, image: UIImage(named: "Exit"), color: .ypRed)
        let nameLabel = addLabel(under: avatarImageView, text: "Екатерина Новикова", font: UIFont.systemFont(ofSize: 23, weight: .bold), color: .ypWhite)
        let tagLabel = addLabel(under: nameLabel, text: "@ekaterina_nov", font: UIFont.systemFont(ofSize: 13), color: .ypGray)
        _ = addLabel(under: tagLabel, text: "Hello, World!", font: UIFont.systemFont(ofSize: 13), color: .ypWhite)
    }
    
    private func updateAvatar() {
        guard
            let imageURLString = ProfileImageService.shared.avatarURLString,
            let url = URL(string: imageURLString)
        else {
            return
        }
        avatarImageView?.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle.fill"))
        print("The picture is loaded, link: ", imageURLString)
    }
}
