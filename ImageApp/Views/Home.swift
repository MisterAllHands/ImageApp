//
//  Home.swift
//  ImageApp
//
//  Created by Mr Producer on 22/01/2024.
//

import SwiftUI


struct Home: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    @State var expand = false
    @State var search = ""
    @State var page = 1
    @State var isSearching = false

    
    
    var body: some View {
                   
            VStack(spacing: 0){
                
                SearchBar(expand: $expand, search: $search, page: $page, isSearching: $isSearching, viewModel: viewModel)
                
                if self.viewModel.images.isEmpty {
                    
                    Spacer()
                    
                    if self.viewModel.noResults{
                        Text("No results found")
                    }else{
                        
                        Indicator()
                    }
                    
                    Spacer()
                    
                }else{
                      
                    SliderView()
                    ImageListView(viewModel: viewModel, isSearching: $isSearching, search: $search, page: $page)
                }
                
            }
            .background(Color.black.opacity(0.1).ignoresSafeArea(edges: .all))
            .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    Home()
}

