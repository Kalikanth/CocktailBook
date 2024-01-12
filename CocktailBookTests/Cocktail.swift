//
//  Cocktail.swift
//  CocktailBookTests
//
//  Created by kiran kumar Gajula on 12/01/24.
//

import Foundation
@testable import CocktailBook

extension Cocktail: Equatable {
    public static func == (lhs: Cocktail, rhs: Cocktail) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func stub() -> Cocktail {
        .init(id: "0",
              name: "Piña colada",
              type: .alcoholic,
              shortDescription: "Velvety-smooth texture and a taste of the tropics are what this tropical drink delivers.",
              longDescription: "he Piña Colada is a Puerto Rican rum drink made with pineapple juice (the name means “strained pineapple” in Spanish) and cream of coconut. By most accounts, the modern-day Piña Colada seems to have originated from a 1954 version that bartender named Ramón “Monchito” Marrero Perez shook up at The Caribe Hilton hotel in San Juan, Puerto Rico. While you may not be sipping this icy-cold tiki drink on the beaches of Puerto Rico, it’s sure to get you in a sunny mood no matter the season.",
              preparationMinutes: 7,
              imageName: "pinacolada",
              ingredients: [
                "4 oz rum",
                "3 oz fresh pineapple juice, chilled (or use frozen pineapple chunks for a smoothie-like texture)",
                "2 oz cream of coconut (or use a combination of sweetened coconut cream and coconut milk)",
                "1 ounce freshly squeezed lime juice (optional)",
                "2 cups ice",
                "Fresh pineapple, for garnish"
              ]
        )
    }
    
    static func dataStub() -> Data {
       return (try? JSONEncoder().encode([Cocktail.stub()])) ?? Data()
    }
}

extension CocktailTVCellViewModel: Equatable {
    public static func == (lhs: CocktailBook.CocktailTVCellViewModel, rhs: CocktailBook.CocktailTVCellViewModel) -> Bool {
        return lhs.isFavourite == rhs.isFavourite && lhs.cocktail == rhs.cocktail
    }
}

extension CocktailMainListViewModel.ViewModelEvent: Equatable{
    public static func == (lhs: CocktailMainListViewModel.ViewModelEvent, rhs: CocktailMainListViewModel.ViewModelEvent) -> Bool {
        switch (lhs, rhs) {
        case let (.loading(lhsValue), .loading(rhsValue)):
            return lhsValue == rhsValue
        case let (.loaded(lhsViewModels), .loaded(rhsViewModels)):
            return lhsViewModels == rhsViewModels
        case (.failed, .failed):
            return true
        case let (.navTitle(lhsTitle), .navTitle(rhsTitle)):
            return lhsTitle == rhsTitle
        default:
            return false
        }
    }
}

extension CocktailDetailViewModel.DetailEvent: Equatable {
    public static func == (lhs: CocktailDetailViewModel.DetailEvent, rhs: CocktailDetailViewModel.DetailEvent) -> Bool {
        switch (lhs,rhs) {
        case let (.favourite(lhsValue), .favourite(rhsValue)):
            return lhsValue == rhsValue
        }
    }
}
