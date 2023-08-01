//
//  CVPresenter.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import Foundation

protocol CVPresenterProtocol {
    var viewController: CVViewControllerProtocol? { get set}
    func prepareModel(model: CVModel, isEditable: Bool)
}

final class CVPresenter: CVPresenterProtocol {
    // MARK: - Public properties
    weak var viewController: CVViewControllerProtocol?
    
    // MARK: - CVPresenterProtocol
    func prepareModel(model: CVModel, isEditable: Bool) {
        let titleData = CVTitleCellData(avatar: model.avatar,
                                        name: model.name,
                                        motto: model.motto,
                                        location: model.location)
        
        var skills = model.skills
        if isEditable {
            skills.append(.addSkillButtonText)
        }
        let skillsData = CVSkillsCellData(skills: skills, isEditable: isEditable)
        
        let aboutData = CVAboutCellData(text: model.about)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showCV(sections: [.title(titleData), .skills(skillsData), .about(aboutData)])
        }
    }
}
