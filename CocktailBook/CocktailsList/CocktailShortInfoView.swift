//
//  CocktailShortInfoView.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 11/01/24.
//

import SwiftUI

struct CocktailShortInfoView: View {
    
    let cocktail: Cocktail
    let isFavorite: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing: 6) {
                Text(cocktail.name)
                    .font(.headline)
                    .foregroundColor(isFavorite ? .red : Color("headline") )
                Text(cocktail.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct CocktailShortInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CocktailShortInfoView(cocktail: Cocktail.createMock(), isFavorite: false)
            CocktailShortInfoView(cocktail: Cocktail.createMock(), isFavorite: false)
                .environment(\.colorScheme, .dark)
        }
    }
}
