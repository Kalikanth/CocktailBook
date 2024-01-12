//
//  CocktailDetailViewModel.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 12/01/24.
//

import Foundation
import Combine

class CocktailDetailViewModel {
    
    enum DetailEvent {
        case favourite(cocktailId: String)
    }
    
    var isFavourite: Bool
    var cocktail: Cocktail
    
    private var dataSubject = PassthroughSubject<DetailEvent, Never>()
    var dataPublisher: AnyPublisher<DetailEvent, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    init(isFavourite: Bool,cocktail:Cocktail) {
        self.isFavourite = isFavourite
        self.cocktail = cocktail
    }
    
    func toggleFavourite() {
        isFavourite.toggle()
        dataSubject.send(.favourite(cocktailId: cocktail.id))
    }
}
