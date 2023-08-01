//
//  NetworkManager.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import UIKit

protocol NetworkManagerProtocol {
    func fetchCV() async throws -> CVModel
}

final class NetworkManager: NetworkManagerProtocol {
    func fetchCV() async throws -> CVModel {
        guard let avatar = UIImage(named: "avatar") else { throw NSError() }
        
        return CVModel(avatar: avatar, name: "Магина Марина Александровна", motto: "Junior iOS-dev, опыт работы 7 месяцев", location: "Ростов-на-Дону", skills: ["Firebase Analytics", "MVVM", "MVC", "SwiftUI", "ООП", "SOLID", "GIT", "MVVMC", "Swift", "UIKit"], about: "Experienced software engineer skilled in developing scalable and maintainable systems")
    }
}
