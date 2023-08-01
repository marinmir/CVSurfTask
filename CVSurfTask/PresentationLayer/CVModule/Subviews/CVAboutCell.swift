//
//  CVAboutCell.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import UIKit

struct CVAboutCellData {
    let text: String
}

final class CVAboutCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    static let reuseIdentifier = "CVAboutCell"
    
    static func height(for screenWidth: CGFloat, data: CVAboutCellData) -> CGFloat {
        let cellWidth = screenWidth - 32
        return 8 + "О себе".height(for: cellWidth, font: .titleFont) + 8 + data.text.height(for: cellWidth, font: .textFont) + 8
    }
    
    // MARK: - Private properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.text = "О себе"
        label.font = .titleFont
        label.textColor = .textBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = .textFont
        label.textColor = .textBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()

    
    // MARK: - Public methods
    
    func configure(data: CVAboutCellData) {
        descriptionLabel.text = data.text
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        contentView.backgroundColor = .whiteBackground
        
        NSLayoutConstraint.activate([
            //title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            //description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
}
