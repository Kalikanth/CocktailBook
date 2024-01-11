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
        case loaded([Cocktail])
        case failed
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
    
    var favoriteCocktails: Set<String> = []
    
    private let service: CocktailsAPI
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: CocktailsAPI) {
        self.service = service
    }
    
    private func filterCocktails(filterType: FilterType) {
        switch filterType {
        case .all:
            filteredCocktails = cocktails
        case .alcoholic:
            filteredCocktails = cocktails.filter { $0.type == .alcoholic }
        case .nonAlcoholic:
            filteredCocktails = cocktails.filter { $0.type == .nonAlcoholic }
        }
      
        let favCocktails = filteredCocktails.filter{ favoriteCocktails.contains($0.id) }
        let nonFavoriteCocktails = filteredCocktails.filter { !favoriteCocktails.contains($0.id) }
        
        filteredCocktails = favCocktails + nonFavoriteCocktails
        self.dataSubject.send(.loaded(filteredCocktails))
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
