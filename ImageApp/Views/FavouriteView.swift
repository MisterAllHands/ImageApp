//
//  FavouriteView.swift
//  ImageApp
//
//  Created by Mr Producer on 23/01/2024.
//

import SwiftUI
import SDWebImageSwiftUI


struct FavouriteView: View {
    
    @ObservedObject var viewModel = ViewModel()

    init() {
        viewModel.loadFavorites()
    }

    var body: some View {
        NavigationView {
            
            if viewModel.favorites.isEmpty{
                VStack(spacing: 30) {
                    
                Image(systemName: "star.fill")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 70, height: 70)


                 Text("You don't have any favourites yet")
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                    
                }
                .foregroundStyle(.gray)
                .padding()
            }else{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        ForEach(viewModel.favorites.chunked(into: 2), id: \.self) { favoritesPair in
                            HStack(spacing: 0) {
                                ForEach(favoritesPair, id: \.self) { favorite in
                                    FavoriteImageView(favorite: favorite, viewModel: viewModel)
                                        .offset(y: shouldOffset(index: favoritesPair.firstIndex(of: favorite) ?? 0) ? 20 : 0)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .navigationBarTitle("Favorites")
                .onAppear {
                    viewModel.loadFavorites()
                }
                .onChange(of: viewModel.favoritesUpdated) { updated in
                    if updated {
                        viewModel.favoritesUpdated = true
                        viewModel.loadFavorites()
                    }
                }
            }
        }
    }

    // Function to determine if offset should be applied based on index
    public func shouldOffset(index: Int) -> Bool {
        return index % 2 == 1 // Apply offset for every second image (index is 0-based)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    FavouriteView()
}

struct FavoriteImageView: View {
    
    var favorite: FavoriteImage
    @StateObject var viewModel: ViewModel
    @State private var shouldDisintegrate: Bool = false


    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
                AnimatedImage(url: URL(string: favorite.imageUrl))
                    .resizable()
                    .frame(width: (UIScreen.main.bounds.width - 50) / 1.9, height: 280)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .cornerRadius(15)
                    .contextMenu {
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                viewModel.removeFromFavorites(imageUrl: favorite.imageUrl)
                            })
                        } label: {
                            HStack {
                                Text("Remove from Favorites")
                                Spacer()
                                Image(systemName: "heart.slash.fill")
                            }
                            .foregroundColor(.red)
                        }
                    }
                
                
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.callout)
                        .foregroundStyle( .red)
                    
                    Text("\(favorite.likes ?? 0) likes")
                        .font(.callout)
                    
                    Image(systemName: "arrow.down.to.line.compact")
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                    
                    Text(formatDownloadCount(favorite.downloads ?? 0))
                        .font(.callout)
                        .fontWeight(.bold)
                }
                
                Text(favorite.altDescription ?? "")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.callout)
                    .padding(.leading,8)
                
        }
        .padding(.horizontal,8)

    }
    
    func formatDownloadCount(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if count >= 1000 {
            let formattedCount = Double(count) / 1000.0
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: formattedCount))?.appending("K") ?? "\(formattedCount)K"
        } else {
            return "\(count)"
        }
    }
}

