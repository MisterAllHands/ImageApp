//
//  ViewModel.swift
//  ImageApp
//
//  Created by Mr Producer on 23/01/2024.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    
    @Published var images: [[Photo]] = []
    @Published var favorites: [FavoriteImage] = []
    @Published var noResults = false
    @Published var favoritesUpdated: Bool = false


    
    init() {
        updateData()
        loadFavorites()
    }
    
    
    public func SearchData(search: String, page: Int){
        let key = "1ZnLWrUT6KzBVcpgrDfu0S4XhkMU_sd5ajLcvNgZ2ZE"
        let query = search.replacingOccurrences(of: " ", with: "%20")
        let url = "https://api.unsplash.com/search/photos/?page=\(page)&query=\(query)&client_id=\(key)"
        
        self.searchData(url: url)
    }
    
    func updateData() {
        
        self.noResults = false
        let key = "U7QuqLnAXu27iQZr8gwS11wXznFHqKTGT3qwnxzmCa8"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!){ (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            do {
                let json = try JSONDecoder().decode([Photo].self, from: data!)
                
                
                for i in stride(from: 0, to: json.count, by: 2){
                    
                    var arrayData: [Photo] = []
                    
                    for j in i..<i+2{
                        if j < json.count{
                            arrayData.append(json[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.images.append(arrayData)
                    }
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    func searchData(url: String) {
        
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!){ (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            do {
                let json = try JSONDecoder().decode(SearchPhoto.self, from: data!)
                
                if json.results.isEmpty {
                    self.noResults = true
                }else{
                    self.noResults = false
                }
                
                for i in stride(from: 0, to: json.results.count, by: 2){
                    
                    var arrayData: [Photo] = []
                    
                    for j in i..<i+2{
                        if j < json.results .count{
                            arrayData.append(json.results[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.images.append(arrayData)
                    }
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
        .resume()
    }


    
    func addToFavorites(imageUrl: String, description: String, likes: Int, downloads: Int ) {
        let favoriteImage = FavoriteImage(imageUrl: imageUrl, altDescription: description, likes: likes, downloads: downloads)
           favorites.append(favoriteImage)
           saveFavorites()
       }

       func removeFromFavorites(imageUrl: String) {
           if let index = favorites.firstIndex(where: { $0.imageUrl == imageUrl }) {
               favorites.remove(at: index)
               saveFavorites()
               loadFavorites()

           }
       }

       func isFavorite(imageUrl: String) -> Bool {
           return favorites.contains { $0.imageUrl == imageUrl }
       }

       private func saveFavorites() {
            do {
                let data = try JSONEncoder().encode(favorites)
                UserDefaults.standard.set(data, forKey: "favorites")
                favoritesUpdated = true  // Signal that favorites have been updated
            } catch {
                print("Error saving favorites: \(error.localizedDescription)")
            }
        }

       func loadFavorites() {
           if let data = UserDefaults.standard.data(forKey: "favorites") {
               do {
                   favorites = try JSONDecoder().decode([FavoriteImage].self, from: data)
               } catch {
                   print("Error loading favorites: \(error.localizedDescription)")
               }
           }
       }
}

