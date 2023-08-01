//
//  CVSkillsCell.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import UIKit

struct CVSkillsCellData {
    let skills: [String]
    let isEditable: Bool
}

protocol CVSkillsCellDelegate: AnyObject {
    func didToggleEditState(_ cell: CVSkillsCell)
    func didTapDelete(_ cell: CVSkillsCell, skill: String)
    func didTapAddSkill()
}

final class CVSkillsCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    static let reuseIdentifier = "CVSkillsCell"
    
    static func height(for screenWidth: CGFloat, data: CVSkillsCellData) -> CGFloat {
        let cellWidth = screenWidth - 32
        var numberOfLines: CGFloat = 1
        var accum: CGFloat = 0
        for skill in data.skills {
            let currentSkillWidth = skillsTextWidth(skill, isEditable: data.isEditable, font: .textFont)
            accum += currentSkillWidth + 12
            if accum > cellWidth {
                numberOfLines += 1
                accum = currentSkillWidth
            }
        }

        return 16 + "Мои навыки".height(for: cellWidth, font: .titleFont) + 16 + numberOfLines * (44 + 12)
    }
    
    private static func skillsTextWidth(_ text: String, isEditable: Bool, font: UIFont) -> CGFloat {
        let textSize = (text as NSString).size(withAttributes: [.font: font])
        return 24 + textSize.width + (isEditable && text != String.addSkillButtonText ? 24 : 0) + 24 + 8
    }
    
    // MARK: - Private properties
    
    weak var delegate: CVSkillsCellDelegate?
    
    private var skills: [String] = []
    private var isEditable: Bool = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.text = "Мои навыки"
        label.font = .titleFont
        label.textColor = .textBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var editSaveButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.editButtonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapToggleEditState), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var skillsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = TagFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(SkillCell.self, forCellWithReuseIdentifier: SkillCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()

    // MARK: - Public methods
    
    func configure(data: CVSkillsCellData) {
        skills = data.skills
        isEditable = data.isEditable
        editSaveButton.setImage(isEditable ? .saveButtonImage : .editButtonImage, for: .normal)
        skillsCollectionView.reloadData()
        skillsCollectionView.collectionViewLayout.invalidateLayout()
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
        contentView.addSubview(editSaveButton)
        contentView.addSubview(skillsCollectionView)
        
        contentView.backgroundColor = .whiteBackground
        
        NSLayoutConstraint.activate([
            //title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: editSaveButton.trailingAnchor, constant: -8),
            
            //button
            editSaveButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            editSaveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editSaveButton.widthAnchor.constraint(equalToConstant: 24),
            editSaveButton.heightAnchor.constraint(equalToConstant: 24),
            
            //collection
            skillsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            skillsCollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            skillsCollectionView.trailingAnchor.constraint(equalTo: editSaveButton.trailingAnchor),
            skillsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ])
    }
    
    @objc private func didTapToggleEditState() {
        delegate?.didToggleEditState(self)
    }
}

// MARK: - UICollectionViewDataSource

extension CVSkillsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillCell.reuseIdentifier, for: indexPath) as! SkillCell
        cell.configure(text: skills[indexPath.row], isEditable: isEditable)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CVSkillsCell: UICollectionViewDelegate {
    
}

extension CVSkillsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: CVSkillsCell.skillsTextWidth(skills[indexPath.row], isEditable: isEditable, font: .textFont),
            height: 44)
    }
}

// MARK: - SkillCellDelegate

extension CVSkillsCell: SkillCellDelegate {
    func didTapDelete(text: String) {
        delegate?.didTapDelete(self, skill: text)
    }
    
    func didTapAdd() {
        delegate?.didTapAddSkill()
    }
}

private extension UIImage {
    static let editButtonImage = UIImage(named: "editButton")
    static let saveButtonImage = UIImage(named: "saveButton")
}
