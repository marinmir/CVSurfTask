//
//  CVBuilder.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import UIKit

final class CVBuilder {
    private lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    
    func build() -> UIViewController {
        let vc = CVViewController()
        let presenter = CVPresenter()
        let interactor = CVInteractor(networkManager: networkManager)
        
        vc.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = vc
        
        return vc
    }
}
