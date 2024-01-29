//
//  Indicator.swift
//  ImageApp
//
//  Created by Mr Producer on 28/01/2024.
//

import SwiftUI

struct Indicator: UIViewRepresentable {

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
    
}
