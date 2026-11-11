//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 09.11.2026.
//

import Foundation


struct MostPopularMovies: Codable {
    let items: [MostPopularMovie]
//    let errorMessage: String
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: Float
    let imageURL: URL

    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"

        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }

        return newURL
    }


    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
