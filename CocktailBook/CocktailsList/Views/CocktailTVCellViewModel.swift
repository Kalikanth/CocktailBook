//
//  CocktailTVCellViewModel.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 12/01/24.
//

import Foundation

class CocktailTVCellViewModel {

    var cocktail: Cocktail
    var isFavourite: Bool
    
    init(cocktail: Cocktail, isFavourite: Bool) {
        self.cocktail = cocktail
        self.isFavourite = isFavourite
    }
    
}
