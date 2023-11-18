//
//  MatchPresenterProtocol.swift
//  ESportsTracker
//
//  Created by f1nch on 17.11.23.
//

import Foundation

//протокол для всех презентеров,тк они должны быть связаны с Моделью и View 
protocol Presenter {
    var model: Model {get set}
    var viewToPresent: View {get set}
}
