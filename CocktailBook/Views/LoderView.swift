//
//  LoderView.swift
//  CocktailBook
//
//  Created by kiran kumar Gajula on 11/01/24.
//

import SwiftUI

struct LoderView: View {
    var body: some View {
        if #available(iOS 14.0, *) {
            ProgressView("Please wait")
        } else {
            Text("Please wait...")
        }
    }
}

struct LoderView_Previews: PreviewProvider {
    static var previews: some View {
        LoderView()
    }
}

extension LoderView {
    static func buildLoaderView(for vc: UIViewController) {
        let loaderView = LoderView()
        let hostingController = UIHostingController(rootView: loaderView)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        hostingController.view.center = vc.view.center
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        vc.addChild(hostingController)
        vc.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: vc)
        hostingController.view.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        hostingController.view.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
    }
}
