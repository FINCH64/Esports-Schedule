//
//  ModelProtocol.swift
//  ESportsTracker
//
//  Created by f1nch on 17.11.23.
//

import Foundation

//Протокол моделей,каждая должна быть связана со своим Presenter)

protocol Model: AnyObject {
    var presenter: Presenter? {get set}
}
