//
//  ViewProtocol.swift
//  ESportsTracker
//
//  Created by f1nch on 5.4.24.
//

import Foundation

protocol View {//протокол для всех view тк они должны быть связаны с презентером
    var presenter: Presenter?{get}
}
