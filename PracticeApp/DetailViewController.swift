//
//  ViewController.swift
//  PracticeApp
//
//  Created by ki Co on 2/16/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var profileImageViewURL: String?
    var idString: String?
    var nameString: String?
    var emailString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setProfileImage(imageUrlString: profileImageViewURL)
        idLabel.text = idString
        nameLabel.text = nameString
        emailLabel.text = emailString
    }
    
    private func setProfileImage(imageUrlString: String?) {
        if let urlString = imageUrlString, let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image =  UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.profileImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
}
