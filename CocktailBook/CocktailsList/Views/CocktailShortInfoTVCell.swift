//
//  CocktailShortInfoTVCell.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 12/01/24.
//

import Foundation
import UIKit
import SwiftUI

class CocktailShortInfoTVCell: UITableViewCell {
    static let reuseIdentifier = "CocktailShortInfoTVCell"

    var hostingController: UIHostingController<CocktailShortInfoView>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configureCell(with viewModel: CocktailTVCellViewModel) {
        let swiftUIView = CocktailShortInfoView(cocktail: viewModel.cocktail,isFavorite: viewModel.isFavourite)
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
