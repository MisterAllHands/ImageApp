//
//  SliderView.swift
//  ImageApp
//
//  Created by Mr Producer on 28/01/2024.
//

import SwiftUI
import SDWebImageSwiftUI


struct SliderView: View {
    
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var selection = 0
    @StateObject var viewM = ViewModel()
    @State private var timeRemaining = 3 // Initial time remaining
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                TabView(selection: $selection) {
                    ForEach(0..<viewM.images.flatMap { $0 }.count, id: \.self) { index in
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                            AnimatedImage(url: URL(string: viewM.images.flatMap { $0 }[index].urls["thumb"]!))
                                .frame(width: UIScreen.main.bounds.width / 1.1, height: 250)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(15)
                                .contextMenu {
                                    
                                    Button {
                                        //add to favorites
                                        if viewM.isFavorite(imageUrl: viewM.images.flatMap { $0 }[index].urls["thumb"]!) {
                                            viewM.removeFromFavorites(imageUrl: viewM.images.flatMap { $0 }[index].urls["thumb"]!)
                                        } else {
                                            if let description = viewM.images.flatMap({ $0 })[index].altDescription, let likes = viewM.images.flatMap({ $0 })[index].likes, let downloads = viewM.images.flatMap { $0 }[index].downloads {
                                                viewM.addToFavorites(imageUrl: viewM.images.flatMap { $0 }[index].urls["thumb"]!, description: description, likes: likes, downloads: downloads)
                                            }
                                        }
                                    }label: {
                                        HStack {
                                            Text(viewM.isFavorite(imageUrl: viewM.images.flatMap { $0 }[index].urls["thumb"]!) ? "Remove from favorites" : "Add to favorites")

                                            Spacer()
                                            
                                            Image(systemName: "star")
                                        }
                                        .foregroundStyle(.black)
                                    }
                                }

                            
                            if let description = viewM.images.flatMap { $0 }[index].altDescription, let likes = viewM.images.flatMap { $0 }[index].likes, let downloads = viewM.images.flatMap { $0 }[index].downloads {
                                VStack {
                                    Text(description)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    HStack(){
                                        // Additional content if needed
                                    }
                                }
                                .padding([.horizontal, .bottom])
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        timeRemaining = 3 // Reset the timer
                        withAnimation {
                            if selection < (viewM.images.flatMap { $0 }.count - 1) {
                                selection += 1
                            } else {
                                selection = 0
                            }
                        }
                    }
                }
            }
            Text("Next image in: \(timeRemaining) seconds")
                .padding()
        }
    }
}
