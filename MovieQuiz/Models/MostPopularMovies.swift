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


    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
