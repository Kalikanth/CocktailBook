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
        case didSelect(Cocktail)
    }
    
    private var tableView: UITableView
    private var dataSource: [Cocktail] = [] {
        didSet {
            self.tableView.reloadData()
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
    
    func set(dataSource: [Cocktail]) {
        self.dataSource = dataSource
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




class CocktailShortInfoTVCell: UITableViewCell {
    static let reuseIdentifier = "CocktailShortInfoTVCell"

    var hostingController: UIHostingController<CocktailShortInfoView>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configureCell(with cocktail: Cocktail) {
        let swiftUIView = CocktailShortInfoView(cocktail: cocktail)
        hostingController = UIHostingController(rootView: swiftUIView)
        hostingController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIView()
        separator.backgroundColor = .secondarySystemBackground
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        NSLayoutConstraint.activate([
        separator.topAnchor.constraint(equalTo: topAnchor),
        separator.leadingAnchor.constraint(equalTo: leadingAnchor),
        separator.trailingAnchor.constraint(equalTo: trailingAnchor),
        separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        if let hostingView = hostingController?.view {
            addSubview(hostingView)

            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: separator.bottomAnchor),
                hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
                hostingView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
