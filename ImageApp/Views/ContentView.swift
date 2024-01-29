//
//  ContentView.swift
//  ImageApp
//
//  Created by Mr Producer on 22/01/2024.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    VStack{
                        Image(systemName: "house")
                            .renderingMode(.template)
                            .foregroundStyle(.black)
                            .font(.headline)
                        
                        Text("Discover")
                            .foregroundStyle(.black)
                            .font(.headline)
                    }
                    .padding()

                }
            
            FavouriteView()
                .tabItem {
                    VStack{
                        Image(systemName: "star")
                            .renderingMode(.template)
                            .foregroundStyle(.yellow)
                            .font(.headline)
                        
                        Text("Favorites")
                            .foregroundStyle(.black)
                            .font(.headline)
                    }
                    .padding()
                }
        }
    }
}

#Preview {
    ContentView()
}
