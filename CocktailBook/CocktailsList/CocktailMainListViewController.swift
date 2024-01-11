//
//  CocktailMainListViewController.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 11/01/24.
//

import UIKit
import Combine

class CocktailMainListViewController: UIViewController, ViewControllerPortocol {

    
    private var cancellables: Set<AnyCancellable> = []
    
    let viewModel: CocktailMainListViewModel = {
        let cocktailApi = FakeCocktailsAPI(withFailure: .count(1))
       return CocktailMainListViewModel(service: cocktailApi)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        viewModel.fetchList()
    }

    func setupBindings() {
        viewModel.dataPublisher
            .sink { [weak self] newData in
                switch newData{
                case let .loading(isVisible):
                    self?.showLoader(isVisible)
                case .loaded(let items):
                    print("itemms loaded:\(items.count)")
                case .failed:
                    let retryAction = UIAlertAction.retryAction { [weak self] _ in
                        self?.viewModel.fetchList()
                    }
                    self?.showAlert(title: "Oops! Fetching failed.", message: "Please try again", actions: [retryAction])
                }
            }.store(in: &cancellables)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
