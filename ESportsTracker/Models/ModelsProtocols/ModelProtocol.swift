//
//  ModelProtocol.swift
//  ESportsTracker
//
//  Created by f1nch on 5.4.24.
//

import Foundation

//Протокол моделей,каждая должна быть связана со своим Presenter)

protocol Model: AnyObject {
    var presenter: Presenter? {get set}
}
