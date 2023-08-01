//
//  CVModel.swift
//  CVSurfTask
//
//  Created by Magina Marina on 01.08.2023.
//

import UIKit

struct CVModel {
    let avatar: UIImage
    let name: String
    let motto: String
    let location: String
    var skills: [String]
    let about: String
    
    mutating func deleteSkill(text: String) {
        skills.removeAll(where: { $0 == text })
    }
    
    mutating func addSkill(text: String) {
        skills.append(text)
    }
}
