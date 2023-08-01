//
//  SkillCell.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import UIKit

protocol SkillCellDelegate: AnyObject {
    func didTapDelete(text: String)
    func didTapAdd()
}

final class SkillCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    static let reuseIdentifier = "SkillCell"
    
    weak var delegate: SkillCellDelegate?
    
    // MARK: - Private properties
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAdd))
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .textBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "deleteButton"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("+", for: .normal)
        button.setTitleColor(.textBlack, for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .horizontal
        
        return stack
    }()
    
    // MARK: - Public methods
    
    func configure(text: String, isEditable: Bool) {
        titleLabel.text = text
        deleteButton.isHidden = !isEditable || text == .addSkillButtonText
        titleLabel.isHidden = text == .addSkillButtonText
        addButton.isHidden = text != .addSkillButtonText
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
    
    @objc private func didTapDelete() {
        delegate?.didTapDelete(text: titleLabel.text ?? "")
    }
    
    @objc private func didTapAdd() {
        delegate?.didTapAdd()
    }
    
    private func setup() {
        contentView.backgroundColor = .grayBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = true
        
        contentView.addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(deleteButton)
        contentStack.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 44),
            
            //delete button
            deleteButton.heightAnchor.constraint(equalToConstant: 14),
            deleteButton.widthAnchor.constraint(equalToConstant: 14),
            
            //add button
            addButton.heightAnchor.constraint(equalToConstant: 14),
            addButton.widthAnchor.constraint(equalToConstant: 14),
            
            //stack
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            contentStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

