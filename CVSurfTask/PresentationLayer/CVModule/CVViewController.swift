//
//  ViewController.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import UIKit

protocol CVViewControllerProtocol: AnyObject {
    func showCV(sections: [CVCollectionViewSection])
}

enum CVCollectionViewSection {
    case title(CVTitleCellData)
    case skills(CVSkillsCellData)
    case about(CVAboutCellData)
}

final class CVViewController: UIViewController, CVViewControllerProtocol {
    
    // MARK: - Public properties
    
    var interactor: CVInteractorProtocol?
    
    // MARK: - Private properties
    
    private var sections: [CVCollectionViewSection] = []
    
    private lazy var cvCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CVTitleCell.self, forCellWithReuseIdentifier: CVTitleCell.reuseIdentifier)
        collectionView.register(CVSkillsCell.self, forCellWithReuseIdentifier: CVSkillsCell.reuseIdentifier)
        collectionView.register(CVAboutCell.self, forCellWithReuseIdentifier: CVAboutCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private lazy var substrateView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .whiteBackground
        
        return view
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        interactor?.onViewDidLoad()
    }
    
    // MARK: - Public methods

    func showCV(sections: [CVCollectionViewSection]) {
        self.sections = sections
        cvCollectionView.reloadData()
    }
    
    // MARK: - Private methods
    private func setup() {
        title = "Профиль"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]
        
        view.backgroundColor = .grayBackground
        view.addSubview(substrateView)
        view.addSubview(cvCollectionView)
        
        
        NSLayoutConstraint.activate([
            cvCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cvCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cvCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cvCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            substrateView.topAnchor.constraint(equalTo: cvCollectionView.centerYAnchor),
            substrateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            substrateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            substrateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension CVViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
        case .title(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVTitleCell.reuseIdentifier, for: indexPath) as! CVTitleCell
            cell.configure(data: data)
            return cell
        case .skills(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVSkillsCell.reuseIdentifier, for: indexPath) as! CVSkillsCell
            cell.configure(data: data)
            cell.delegate = self
            return cell
        case .about(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVAboutCell.reuseIdentifier, for: indexPath) as! CVAboutCell
            cell.configure(data: data)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CVViewController: UICollectionViewDelegate {
    
}

extension CVViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        switch sections[indexPath.section] {
        case .title(let data):
            return CGSize(width: screenWidth, height: CVTitleCell.height(for: screenWidth, data: data))
        case .skills(let data):
            return CGSize(width: screenWidth, height: CVSkillsCell.height(for: screenWidth, data: data))
        case .about(let data):
            return CGSize(width: screenWidth, height: CVAboutCell.height(for: screenWidth, data: data))
        }
    }
}

// MARK: - CVSkillsCellDelegate

extension CVViewController: CVSkillsCellDelegate {
    func didToggleEditState(_ cell: CVSkillsCell) {
        interactor?.didToggleEditState()
    }
    
    func didTapDelete(_ cell: CVSkillsCell, skill: String) {
        interactor?.didTapDelete(skill: skill)
    }
    
    func didTapAddSkill() {
        let alertController = UIAlertController(title: "Добавление навыка", message: "Введите название навыка, которым вы владеете", preferredStyle: .alert)
        alertController.addTextField() { textField in
            textField.placeholder = "Введите название"
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] alert in
            guard let textField = alertController.textFields?.first, let text = textField.text else {
                return
            }
            self?.interactor?.didAddSkill(text)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        alertController.preferredAction = addAction
        
        present(alertController, animated: true)
    }
}
