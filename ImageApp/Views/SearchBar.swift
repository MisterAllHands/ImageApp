//
//  SearchBar.swift
//  ImageApp
//
//  Created by Mr Producer on 28/01/2024.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var expand: Bool
    @Binding var search: String
    @Binding var page: Int
    @Binding var isSearching: Bool
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack{
            if !self.expand {
                VStack(alignment: .leading, spacing: 8){
                    
                    Text("ImageRowser")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Creative, Free Photos")
                        .font(.caption)
                }
                .foregroundStyle(.black)
            }
            
            
            Spacer(minLength: 0)
            
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
                .onTapGesture {
                    withAnimation {
                        self.expand = true
                    }
                }
            
            if expand {
                TextField("Search...", text: $search)
                
                if self.search != "" {
                    Button(action: {
                        
                        self.viewModel.images.removeAll()
                        self.isSearching = true
                        self.page = 1
                        self.viewModel.SearchData(search: search, page: page)
                        
                    }, label: {
                        Text("Find")
                            .fontWeight(.bold)
                            .foregroundStyle(.black )
                    })
                }
                
                Button(action: {
                    withAnimation {
                        self.expand = false
                    }
                    
                    self.search = ""
                    
                    if self.isSearching{
                        self.isSearching = false
                        self.viewModel.images.removeAll()
                        self.viewModel.updateData()
                    }
                    
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.black)
                })
                .padding(.leading,10 )
            }
            
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .padding()
        .background(.white)
    }
}
