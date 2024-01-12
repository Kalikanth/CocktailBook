//
//  CocktailDetailViewModelTests.swift
//  CocktailBookTests
//
//  Created by kiran kumar Gajula on 12/01/24.
//

import Foundation
import XCTest
import Combine
@testable import CocktailBook

class CocktailDetailViewModelTests: XCTestCase {

    var viewModel: CocktailDetailViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        let mockCocktail = Cocktail.stub()
        viewModel = CocktailDetailViewModel(isFavourite: false, cocktail: mockCocktail)
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testToggleFavourite() {
        // Given
        let expectation = XCTestExpectation(description: "Toggle Favourite")
        var eventReceived: CocktailDetailViewModel.DetailEvent?

        // When
        viewModel.dataPublisher
            .sink { event in
                eventReceived = event
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.toggleFavourite()

        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(eventReceived, .favourite(cocktailId: "0"))
        XCTAssertTrue(self.viewModel.isFavourite)
    }
}
