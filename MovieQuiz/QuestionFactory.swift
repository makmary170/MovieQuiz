//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Мария Макарова on 19.10.2026.
//
import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []

    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }

    func loadData() {
        moviesLoader.loadMovies {
            [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let MostPopularMovies):
                    self.movies = MostPopularMovies.items // сохраняем фильм
                    self.delegate?.didLoadDataFromServer() // данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // если ошибка
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0

            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()

            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image!")
                self.delegate?.didFailToLoadImage(with: error)
            }

            let randomInt = Int.random(in: (7...9))
            let text = "Рейтинг этого фильма больше чем \(randomInt)?"
            let correctAnswer = movie.rating > Float(randomInt)

            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer
            )

            DispatchQueue.main.async { [ weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }

//    private let questions: [QuizQuestion] = [
//        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
//        ]

}
