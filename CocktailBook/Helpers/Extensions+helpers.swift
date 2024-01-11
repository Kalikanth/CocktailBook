//
//  Extensions+helpers.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 11/01/24.
//

import Foundation
import UIKit

extension UIAlertAction {
    
    static func ok() -> UIAlertAction {
        UIAlertAction(title: "Ok", style: .default)
    }
    
    static func retryAction(_ handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        UIAlertAction(title: "Retry", style: .default,handler: handler)
    }
}

extension UserDefaults {
    static let favouriets = "UserFavourites"
    
    static func save(_ value: Any,for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func saveUser(favourites: Set<String>) {
        save(favourites, for: UserDefaults.favouriets)
    }
    
    static func getUserFavourites() -> Set<String> {
        UserDefaults.standard.value(forKey: favouriets) as! Set<String>
    }
}
