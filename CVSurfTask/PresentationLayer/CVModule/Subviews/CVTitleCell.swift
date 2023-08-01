//
//  CVTitleCell.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import UIKit

struct CVTitleCellData {
    let avatar: UIImage
    let name: String
    let motto: String
    let location: String
}

final class CVTitleCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    static let reuseIdentifier = "CVTitleCell"
    
    static func height(for screenWidth: CGFloat, data: CVTitleCellData) -> CGFloat {
        let cellWidth = screenWidth - 32
        return 24 + 120 + 16 + data.name.height(for: cellWidth, font: .largeTitleFont) + 4 +
        data.motto.height(for: cellWidth, font: .textFont) + data.location.height(for: cellWidth, font: .textFont) + 32
    }
    
    // MARK: - Private properties
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.font = .largeTitleFont
        label.textColor = .textBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var mottoLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.font = .textFont
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .textGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .textFont
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .textGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var locationPinView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cvLocationPin"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var locationStack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 2
        stack.axis = .horizontal
        
        return stack
    }()
    
    // MARK: - Public methods
    
    func configure(data: CVTitleCellData) {
        avatarImageView.image = data.avatar
        nameLabel.text = data.name
        mottoLabel.text = data.motto
        locationLabel.text = data.location
        
        for stackSubview in locationStack.arrangedSubviews {
            locationStack.removeArrangedSubview(stackSubview)
            stackSubview.removeFromSuperview()
        }
        
        locationStack.addArrangedSubview(locationPinView)
        locationStack.addArrangedSubview(locationLabel)
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setup() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(mottoLabel)
        contentView.addSubview(locationStack)
        
        contentView.backgroundColor = .grayBackground
        
        NSLayoutConstraint.activate([
            //avatar
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            //name
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            //motto
            mottoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            mottoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mottoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            //pin + location
            locationPinView.widthAnchor.constraint(equalToConstant: 16),
            locationPinView.heightAnchor.constraint(equalToConstant: 16),
            
            locationStack.topAnchor.constraint(equalTo: mottoLabel.bottomAnchor),
            locationStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            locationStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
}
