//
//  CocktailMainListViewModelTests.swift
//  CocktailBookTests
//
//  Created by kiran kumar Gajula on 12/01/24.
//

import Foundation
import XCTest
import Combine
@testable import CocktailBook 

class CocktailMainListViewModelTests: XCTestCase {

    var viewModel: CocktailMainListViewModel!
    var service: MockCocktailsAPI!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        service = MockCocktailsAPI()
        viewModel = CocktailMainListViewModel(service: service)
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        super.tearDown()
    }

    func testFetchListSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch List Success")
        let mockCocktails = [Cocktail.stub()]
        service.cocktailsPublisher = Just(Cocktail.dataStub())
                                        .setFailureType(to: CocktailsAPIError.self)
                                        .eraseToAnyPublisher()
        
        // When
        viewModel.fetchList()
        
        // Then
        viewModel.dataPublisher
            .sink { event in
                switch event {
                case .loading(let isLoading):
                    if isLoading {
                        XCTAssertEqual(event, .loading(true))
                    } else {
                        XCTAssertEqual(event, .loading(false))
                    }
                case .loaded(_):
                    XCTAssertEqual(event, .loaded([CocktailTVCellViewModel(cocktail: mockCocktails[0], isFavourite: false)]))
                    expectation.fulfill()
                
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

    func testFetchListFailure() {
        let expectation = XCTestExpectation(description: "Fetch List Failure")
        service.cocktailsPublisher = Fail(error: CocktailsAPIError.unavailable)
            .eraseToAnyPublisher()
        
        // When
        viewModel.fetchList()
        
        // Then
        viewModel.dataPublisher
            .sink { event in
                switch event {
                case .loading(let isLoading):
                    if isLoading {
                        XCTAssertEqual(event, .loading(true))
                    } else {
                        XCTAssertEqual(event, .loading(false))
                        expectation.fulfill()
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

    func testToggleFavorite() {
        // Given
        let cocktailId = "1"

        // When
        viewModel.toggleFavorite(cocktailId: cocktailId)

        // Then
        XCTAssertTrue(viewModel.favoriteCocktails.contains(cocktailId))

        // When
        viewModel.toggleFavorite(cocktailId: cocktailId)

        // Then
        XCTAssertFalse(viewModel.favoriteCocktails.contains(cocktailId))
    }
    
    func testFilters() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch List and apply filters success")
        service.cocktailsPublisher = Just(Cocktail.dataStub())
                                        .setFailureType(to: CocktailsAPIError.self)
                                        .eraseToAnyPublisher()
        
        // When
        viewModel.filterType = .nonAlcoholic
        viewModel.fetchList()
        
        // Then
        viewModel.dataPublisher
            .sink { event in
                switch event {
                case .loaded(_):
                    XCTAssertEqual(event, .loaded([]))
                    expectation.fulfill()
                
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
}

class MockCocktailsAPI: CocktailsAPI {
    var cocktailsPublisher: AnyPublisher<Data, CocktailBook.CocktailsAPIError> = Empty().eraseToAnyPublisher()
    
    func fetchCocktails(_ handler: @escaping (Result<Data, CocktailBook.CocktailsAPIError>) -> Void) {
        
    }

    func cocktails() -> AnyPublisher<Data, CocktailBook.CocktailsAPIError> {
        return cocktailsPublisher
    }
}
