//
//  Game.swift
//  OpenQuizz
//
//  Created by christophe milliere on 09/09/2017.
//  Copyright © 2017 christophe milliere. All rights reserved.
//

import Foundation

class Game {
    
    var score = 0
    var questions:[Question] = []
    
    enum State {
        case ongoing, over
    }
    
    var state: State = .ongoing
    private var currentIndex = 0
    
    var currentQuestion: Question {
        get {
            return questions[currentIndex]
        }
    }
    
    private func receiveQuestions(_ questions: [Question]) {
        self.questions = questions
        state = .ongoing
    }
    
    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            
        }
    }
    
    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
        }
        goToNextQuestion()
    }
    
    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }
    
    private func finishGame() {
        state = .over
    }
}
