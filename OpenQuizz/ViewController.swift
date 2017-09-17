//
//  ViewController.swift
//  OpenQuizz
//
//  Created by christophe milliere on 09/09/2017.
//  Copyright © 2017 christophe milliere. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionLoaded), name: name, object: nil)
        
        startNewGame()
        
        let panGestureReccognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureReccognizer)
    }
    
    
    
    func questionLoaded(){
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame(){
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        
        questionView.title = "Loading..."
        questionView.style = .standard
        
        scoreLabel.text = "0 / 10"
        
        game.refresh()
        
    }
    
    func dragQuestionView(_ sender: UIPanGestureRecognizer){
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: questionView)
        
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x/(screenWidth / 2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        }else{
            questionView.style = .incorrect
        }
        
        
    }
    
    private func answerQuestion(){
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
            changeLabel(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
            changeLabel(with: false)
        case .standard:
            break
        }

        scoreLabel.text = "\(game.score) /10"
        
        questionView.transform = .identity
        questionView.style = .standard
        questionView.title = game.currentQuestion.title
        
        
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        
        if questionView.style == .correct{
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        }else{
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(withDuration: 0.3,animations: {
            self.questionView.transform = translationTransform
        }, completion: { (success) in
            if success {
                self.showQuestionView()
            }
        })
    }
    
    private func changeLabel(with answer: Bool) {
        if (game.questionIsCorrect) {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scoreLabel.alpha = 0.5
                self.scoreLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }, completion: { success in
                
                if success {
                    self.scoreLabel.alpha = 1
                    self.scoreLabel.textColor = UIColor.white
                }
            })
        }

    }
    
    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        questionView.style = .standard
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            finish()
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion:nil)
    }
    
    
    private func finish(){
        if game.score < 6{
            questionView.title = "Game Over"
            finishAnimation(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        }else{
            questionView.title = " Vous avez gagner!!"
            finishAnimation(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        }
    }
    
    
    private func finishAnimation(color: UIColor){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scoreLabel.alpha = 0.5
            self.questionView.backgroundColor = color
        }, completion: { success in
            
            if success {
                self.scoreLabel.alpha = 1
                self.scoreLabel.textColor = color
            }
        })
    }

}

