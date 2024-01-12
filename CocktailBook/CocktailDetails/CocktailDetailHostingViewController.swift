//
//  CocktailDetailHostingViewController.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 12/01/24.
//

import Foundation
import UIKit
import SwiftUI

class CocktailDetailHostingViewController: UIHostingController<CocktailDetailView> {
    
    private var rightBarButton: UIBarButtonItem!
    var viewModel: CocktailDetailViewModel
    
    @MainActor init(view: CocktailDetailView, viewModel: CocktailDetailViewModel) {
        self.viewModel = viewModel
        super.init(rootView: view)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let image = viewModel.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        rightBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapFavorite))
        rightBarButton.tintColor = .red
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func didTapFavorite() {
        viewModel.toggleFavourite()
        let image = viewModel.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        rightBarButton.image = image
    }
    
}

extension CocktailDetailHostingViewController {
    static func buildVC(viewModel: CocktailDetailViewModel) -> CocktailDetailHostingViewController {
        let detailView = CocktailDetailView(cocktail: viewModel.cocktail)
        return CocktailDetailHostingViewController(view: detailView, viewModel: viewModel)
    }
}
