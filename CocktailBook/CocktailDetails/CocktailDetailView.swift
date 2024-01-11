//
//  CocktailDetailView.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 12/01/24.
//

import SwiftUI

struct CocktailDetailView: View {
    
    let cocktail: Cocktail
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        VStack(alignment: .leading,spacing: 2) {
                            Text(cocktail.name)
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("headline"))
                            HStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .frame(width: 10,height: 10)
                                    .foregroundColor(.gray)
                                Text(cocktail.minutesToPrepare)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    Image(cocktail.imageName)
                        .resizable()
                        .frame(width: geometry.size.width,height: geometry.size.height * 0.3)
                    VStack {
                        Text(cocktail.longDescription)
                            .fontWeight(.regular)
                        HStack {
                            Text("Ingredients")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8))
                            Spacer()
                        }
                        ForEach(cocktail.ingredients,id: \.self) { item in
                            HStack(alignment: .top) {
                                Image(systemName: "arrowtriangle.right.fill")
                                    .resizable()
                                    .frame(width: 10,height: 10)
                                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
                                Text(item)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct CocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailDetailView(cocktail: Cocktail.createMock())
    }
}
