//
//  CocktailMainListViewController.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 11/01/24.
//

import UIKit
import Combine

class CocktailMainListViewController: UIViewController, ViewControllerPortocol {

    @IBOutlet weak var segmentView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    private var cancellables: Set<AnyCancellable> = []
    
    let viewModel: CocktailMainListViewModel = {
        let cocktailApi = FakeCocktailsAPI(withFailure: .count(1))
       return CocktailMainListViewModel(service: cocktailApi)
    }()
    
    var dataSourceHandler: CocktailDataSourceHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseDataSourceHandler()
        setupBindings()
        viewModel.fetchList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFilters()
    }
    
    private func initialiseDataSourceHandler() {
        let handler = CocktailDataSourceHandler(tableView: self.tableView)
        handler.dataPublisher
            .sink { [weak self] event in
                switch event {
                case let .didSelect(cocktail):
                    print("selected cocktail name:\(cocktail.name)")
                }
            }
            .store(in: &cancellables)
        dataSourceHandler = handler
    }

    func setupBindings() {
        viewModel.dataPublisher
            .sink { [weak self] newData in
                switch newData{
                case let .loading(isVisible):
                    self?.showLoader(isVisible)
                case .loaded(let items):
                    print("itemms loaded:\(items.count)")
                    self?.dataSourceHandler.set(dataSource: items)
                case .failed:
                    let retryAction = UIAlertAction.retryAction { [weak self] _ in
                        self?.viewModel.fetchList()
                    }
                    self?.showAlert(title: "Oops! Fetching failed.", message: "Please try again", actions: [retryAction])
                case .navTitle(let title):
                    self?.navigationController?.title = title
                }
            }.store(in: &cancellables)
    }
    
    private func setupFilters() {
        let segmentedControl = UISegmentedControl(items: FilterType.allCases.map{ $0.rawValue })
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.segmentView.addArrangedSubview(segmentedControl)
    }
    
    @objc private func segmentAction(_ segmentedControl: UISegmentedControl) {
        self.viewModel.filterType = FilterType.allCases[segmentedControl.selectedSegmentIndex]
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

extension CocktailMainListViewController {
    static func buildVC() -> UINavigationController {
        let cocktailVC = CocktailMainListViewController()
        cocktailVC.navigationItem.title = FilterType.all.rawValue
        let navVC = UINavigationController(rootViewController: cocktailVC)
        return navVC
    }
}
