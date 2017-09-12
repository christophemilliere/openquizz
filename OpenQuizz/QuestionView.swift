//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by christophe milliere on 12/09/2017.
//  Copyright © 2017 christophe milliere. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    enum Style {
        case correct,incorrect, standard
    }
    
    var style = Style.standard {
        didSet{
            setStyle(style)
        }
    }
    
    private func setStyle(_ style: Style){
        switch style {
        case .correct:
            backgroundColor = UIColor(red: 200/255, green: 236/255, blue: 160/255, alpha: 1)
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9608765244, green: 0.5257816911, blue: 0.5753855109, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Error")
            icon.isHidden = false
        case .standard:
            backgroundColor = #colorLiteral(red: 0.7483419776, green: 0.7683829665, blue: 0.7891533971, alpha: 1)
            icon.isHidden = true
        }
    }
    
    var title = ""{
        didSet{
            label.text = title
        }
    }
    
    
    
}
