//
//  CocktailMainListViewModel.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 11/01/24.
//

import Foundation
import Combine


class CocktailMainListViewModel {
    
    enum ViewModelEvent {
        case loading(Bool)
        case loaded([CocktailTVCellViewModel])
        case failed
        case navTitle(String)
    }
    
    private var dataSubject = PassthroughSubject<ViewModelEvent, Never>()
    var dataPublisher: AnyPublisher<ViewModelEvent, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    private var cocktails: [Cocktail] = []
    private var filteredCocktails: [Cocktail] = []
    var filterType: FilterType = .all {
        didSet {
            self.filterCocktails(filterType: filterType)
        }
    }
    
    var favoriteCocktails: Set<String> = [] {
        didSet {
            UserDefaults.saveUser(favourites: Array(favoriteCocktails))
        }
    }
    
    private let service: CocktailsAPI
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: CocktailsAPI) {
        self.service = service
        self.favoriteCocktails = UserDefaults.getUserFavourites()
    }
    
    private func filterCocktails(filterType: FilterType) {
        self.dataSubject.send(.navTitle(filterType.navTitle))
        switch filterType {
        case .all:
            filteredCocktails = cocktails
        case .alcoholic:
            filteredCocktails = cocktails.filter { $0.type == .alcoholic }
        case .nonAlcoholic:
            filteredCocktails = cocktails.filter { $0.type == .nonAlcoholic }
        }
      
        let favCocktails = filteredCocktails.filter{ favoriteCocktails.contains($0.id) }.sorted(by: { $0.name < $1.name })
        let nonFavoriteCocktails = filteredCocktails.filter { !favoriteCocktails.contains($0.id) }.sorted(by: { $0.name < $1.name })
        
        filteredCocktails = favCocktails + nonFavoriteCocktails
        let viewModels = filteredCocktails.map{ mapToViewModel(cocktail: $0) }
        self.dataSubject.send(.loaded(viewModels))
    }
    
    func mapToViewModel(cocktail: Cocktail) -> CocktailTVCellViewModel {
        let isFavourite = favoriteCocktails.contains(cocktail.id)
        return CocktailTVCellViewModel(cocktail: cocktail, isFavourite: isFavourite)
    }
    
    func toggleFavorite(cocktailId: String) {
        if favoriteCocktails.contains(cocktailId) {
            favoriteCocktails.remove(cocktailId)
        } else {
            favoriteCocktails.insert(cocktailId)
        }
        filterCocktails(filterType: filterType)
    }
    
    func fetchList() {
        dataSubject.send(.loading(true))
        service.cocktailsPublisher
            .decode(type: [Cocktail].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(_):
                    self?.dataSubject.send(.failed)
                case .finished:
                    // do nothing
                    print("Successfully fetched")
                }
                self?.dataSubject.send(.loading(false))
            }) { [weak self] cocktails in
                self?.cocktails = cocktails
                self?.filterCocktails(filterType: self?.filterType ?? .all)
            }
            .store(in: &cancellables)
    }
    
}
