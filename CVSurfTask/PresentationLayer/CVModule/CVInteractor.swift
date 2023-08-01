//
//  CVInteractor.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import Foundation

protocol CVInteractorProtocol {
    var presenter: CVPresenterProtocol? { get set}
    func onViewDidLoad()
    func didToggleEditState()
    func didTapDelete(skill: String)
    func didAddSkill(_ skill: String)
}

final class CVInteractor: CVInteractorProtocol {
    // MARK: - Public properties
    
    var presenter: CVPresenterProtocol?
    
    // MARK: - Private properties
    
    private var isEditable = false
    private var model: CVModel?
    
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Life Cycle
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    // MARK: - CVInteractorProtocol
    
    func onViewDidLoad() {
        Task {
            do {
                let cvModel = try await networkManager.fetchCV()
                model = cvModel
                showCV()
            } catch {
                print(error)
            }
        }
    }
    
    func didToggleEditState() {
        isEditable.toggle()
        showCV()
    }
    
    func didTapDelete(skill: String) {
        model?.deleteSkill(text: skill)
        showCV()
    }
    
    func didAddSkill(_ skill: String) {
        model?.addSkill(text: skill)
        showCV()
    }
    
    // MARK: - Private methods
    
    private func showCV() {
        guard let model = model else {
            return
        }
        
        presenter?.prepareModel(model: model, isEditable: isEditable)
    }
}
