//
//  CocktailDataSourceHandler.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 11/01/24.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class CocktailDataSourceHandler: NSObject {
    
    enum DataSourceEvent {
        case didSelect(CocktailTVCellViewModel)
    }
    
    private var tableView: UITableView
    private var dataSource: [CocktailTVCellViewModel] = [] {
        didSet {
            reloadTableView()
        }
    }
    
    private var dataSubject = PassthroughSubject<DataSourceEvent, Never>()
    var dataPublisher: AnyPublisher<DataSourceEvent, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CocktailShortInfoTVCell.self, forCellReuseIdentifier: CocktailShortInfoTVCell.reuseIdentifier)
    }
    
    func set(dataSource: [CocktailTVCellViewModel]) {
        self.dataSource = dataSource
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension CocktailDataSourceHandler: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CocktailShortInfoTVCell.reuseIdentifier, for: indexPath) as! CocktailShortInfoTVCell
        cell.configureCell(with: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSubject.send(.didSelect(dataSource[indexPath.row]))
    }
}
