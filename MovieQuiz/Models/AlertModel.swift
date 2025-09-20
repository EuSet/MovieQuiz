//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Евгений Сецко on 13.09.25.
//

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
