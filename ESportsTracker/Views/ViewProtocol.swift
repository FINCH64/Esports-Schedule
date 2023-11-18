//
//  ViewProtocol.swift
//  ESportsTracker
//
//  Created by f1nch on 17.11.23.
//

import Foundation

protocol View {//протокол для всех view тк они должны быть связаны с презентером
    var presenter: Presenter?{get}
}
