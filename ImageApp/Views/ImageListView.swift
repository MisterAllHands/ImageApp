//
//  ImageListView.swift
//  ImageApp
//
//  Created by Mr Producer on 28/01/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageListView: View {
    
    @ObservedObject var viewModel: ViewModel
    @Binding var isSearching: Bool
    @Binding var search: String
    @Binding var page: Int
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 15){
                ForEach(viewModel.images, id: \.self){i in
                    HStack(spacing: 20){
                        ForEach(i){j in
                            VStack(alignment: .leading, spacing: 10) {
                                AnimatedImage(url: URL(string: j.urls["thumb"]!))
                                    .resizable()
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 1.9, height: 280)
                                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(15)
                                    .contextMenu {
                                        //Favorites
                                        
                                        Button {
                                            //add to favorites
                                            if viewModel.isFavorite(imageUrl: j.urls["thumb"]!) {
                                                viewModel.removeFromFavorites(imageUrl: j.urls["thumb"]!)
                                            } else {
                                                viewModel.addToFavorites(imageUrl: j.urls["thumb"]!, description: j.altDescription ?? "", likes: j.likes ?? 0, downloads: j.downloads ?? 0)
                                            }
                                        } label: {
                                            HStack {
                                                Text(viewModel.isFavorite(imageUrl: j.urls["thumb"]!) ? "Remove from favorites" : "Add to favorites")
                                                   
                                                
                                                Spacer()
                                                
                                                Image(systemName: "star")
                                            }
                                            .foregroundStyle(.black)
                                        }
                                    }
                                
                                
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .font(.callout)
                                        .foregroundStyle( .red)
                                    
                                    Text("\(j.likes ?? 0) likes")
                                        .font(.callout)
                                    
                                    Image(systemName: "arrow.down.to.line.compact")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.green)
                                    
                                    Text(formatDownloadCount(j.downloads ?? 0))
                                        .font(.callout)
                                        .fontWeight(.bold)
                                }
                                
                                
                                HStack {
                                    Text(((j.location?.country?.isEmpty) != nil) ? "Location:" : "")
                                        .font(.callout)
                                        .fontWeight(.regular)
                                        .foregroundStyle(.black)
                                    
                                    Text(j.location?.country ?? "")
                                        .foregroundStyle(.black)
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .lineLimit(nil)
                                }
                                .padding(.horizontal, 5)
                            }
                        }
                    }
                }
                
                if !self.viewModel.images.isEmpty {
                    if self.isSearching && self.search != ""{
                        HStack{
                            
                            Text("Page \(self.page)")
                            
                            Spacer()
                            
                            Button {
                                self.viewModel.images.removeAll()
                                self.page += 1
                                self.viewModel.SearchData(search: search, page: page)
                            } label: {
                                Text("Next")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.black)
                            }
                            
                        }
                        .padding(.horizontal,25)
                    }else{
                        HStack{
                            Spacer()
                            
                            Button {
                                self.viewModel.images.removeAll()
                                self.viewModel.updateData()
                            } label: {
                                Text("Next")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.black)
                            }
                            
                        }
                        .padding(.horizontal,25)
                    }
                }
            }
            .padding(.top)
        }

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
