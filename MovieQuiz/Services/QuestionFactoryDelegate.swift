//
//  QuestionQuizProtocol.swift
//  MovieQuiz
//
//  Created by Евгений Сецко on 11.09.25.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(_ question: QuizQuestion?)
}
