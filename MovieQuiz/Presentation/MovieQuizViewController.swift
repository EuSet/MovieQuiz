import UIKit

final class MovieQuizViewController: UIViewController {
    //MARK: - IB Outlets
    @IBOutlet weak private var questionTitleLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var questionCounterLabel: UILabel!
    
    @IBOutlet weak private var imageView: UIImageView!
    
    @IBOutlet weak private var yesAnswerButton: UIButton!
    @IBOutlet weak private var noAnswerButton: UIButton!
    
    // MARK: - Private Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }

    private struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }

    private struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    ]
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        yesAnswerButton.layer.cornerRadius = 15
        noAnswerButton.layer.cornerRadius = 15
        questionLabel.font = UIFont(name: AppFontName.displayMedium, size: 23)
        questionCounterLabel.font = UIFont(name: AppFontName.displayMedium, size: 20)
        questionTitleLabel.font = UIFont(name: AppFontName.displayMedium, size: 20)
        yesAnswerButton.titleLabel?.font = UIFont(name: AppFontName.displayMedium, size: 20)
        noAnswerButton.titleLabel?.font = UIFont(name: AppFontName.displayMedium, size: 20)
        showQuestionHandler()
        
    }
    
    // MARK: - IB Actions
    @IBAction private func handleYesButtonTouchUp(_ sender: UIButton) {
        handleAnswerResult(answer: true)
    }
    
    @IBAction private func handleNoButtonTouchUp(_ sender: UIButton) {
        handleAnswerResult(answer: false)
    }
    
    // MARK: - Private Methods
    private func disableAnswerButtons() {
        yesAnswerButton.isEnabled = false
        noAnswerButton.isEnabled = false
    }
    
    private func enableAnswerButtons() {
        yesAnswerButton.isEnabled = true
        noAnswerButton.isEnabled = true
    }
    
    private func handleAnswerResult(answer: Bool) {
        disableAnswerButtons()
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        let isCorrectAnswer: Bool = correctAnswer == answer
        if isCorrectAnswer {
            correctAnswers += 1
        }
        showAnswerResult(isCorrect: isCorrectAnswer)
        let isQuizFinished: Bool = currentQuestionIndex == questions.count - 1
        if isQuizFinished {
            show(quiz: QuizResultsViewModel(title: "Раунд окончен!", text: "Ваш результат: \(correctAnswers)/\(questions.count)", buttonText: "Ок"))
            enableAnswerButtons()
        } else {
            currentQuestionIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showQuestionHandler()
                self.resetImageBorderStyle()
                self.enableAnswerButtons()
            }

        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
      return QuizStepViewModel(
            image: UIImage(named: model.image)!,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        questionCounterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            self.resetImageBorderStyle()
            self.showQuestionHandler()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showQuestionHandler() {
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    private func setImageBorderStyle(_ color: UIColor, _ width: CGFloat) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        setImageBorderStyle(isCorrect ? UIColor.ypGreen : UIColor.ypRed, 8)
    }
    
    private func resetImageBorderStyle() {
        setImageBorderStyle(UIColor.systemGray, 0)
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
