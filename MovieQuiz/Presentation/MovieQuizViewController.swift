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
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
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
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticService()
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
        guard let correctAnswer = currentQuestion?.correctAnswer else {
            return
        }
        disableAnswerButtons()
        let isCorrectAnswer: Bool = correctAnswer == answer
        if isCorrectAnswer {
            correctAnswers += 1
        }
        showAnswerResult(isCorrect: isCorrectAnswer)
        let isQuizFinished: Bool = currentQuestionIndex == questionsAmount - 1
        if isQuizFinished {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let alertInfoMessage = createAlertInfoMessage()
            let result = QuizResultsViewModel(title: "Раунд окончен!", text: alertInfoMessage, buttonText: "Ок")
            let alertModel = AlertModel(
                title: result.title,
                message: result.text,
                buttonText: result.buttonText,
                completion: { [weak self] in
                    guard let self else { return }
                    self.correctAnswers = 0
                    self.currentQuestionIndex = 0
                    self.resetImageBorderStyle()
                    self.questionFactory?.requestNextQuestion()
                    
                }
            )
            alertPresenter?.createAlert(model: alertModel)
            enableAnswerButtons()
        } else {
            currentQuestionIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self else { return }
                self.questionFactory?.requestNextQuestion()
                self.resetImageBorderStyle()
                self.enableAnswerButtons()
            }

        }
    }
    
    private func createAlertInfoMessage() -> String {
        guard let statisticService else {
            return "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        }
        let gamesCount = statisticService.gamesCount
        let bestGame = statisticService.bestGame
        let totalAccuracy = statisticService.totalAccuracy
        return "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\nСредняя точность \(String(format: "%.2f", totalAccuracy))%"
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
      return QuizStepViewModel(
            image: UIImage(named: model.image)!,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        questionCounterLabel.text = step.questionNumber
    }
    
    private func showQuestionHandler(current question: QuizQuestion) {
        self.currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.show(quiz: self.convert(model: question))
        }
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

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didRecieveNextQuestion(_ question: QuizQuestion?) {
        guard let question else {
            return //error handler
        }
        showQuestionHandler(current: question)
    }
}

extension MovieQuizViewController: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}


