//
//  SettingParametersViewController.swift
//  InfectionApp
//
//  Created by Danil Antonov on 24.03.2024.
//

import UIKit

class SettingParametersViewController: UIViewController {

    private let countPeopleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Количество людей в группе"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    private let countPeopleField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите число"
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        
        return textField
    }()
    private let countInfectedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Количество людей, которое может быть заражено одним человеком"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    private let countInfectedField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите число"
        textField.keyboardType = .numberPad
        textField.textAlignment = .center

        return textField
    }()
    private let timeRecalculationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Период пересчёта количества заражённых людей (сек)"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    private let timeRecalculationField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите число"
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        
        return textField
    }()
    private let buttonNext: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stack.addArrangedSubview(countPeopleLabel)
        stack.addArrangedSubview(countPeopleField)
        stack.addArrangedSubview(countInfectedLabel)
        stack.addArrangedSubview(countInfectedField)
        stack.addArrangedSubview(timeRecalculationLabel)
        stack.addArrangedSubview(timeRecalculationField)
        stack.addArrangedSubview(buttonNext)
        
        view.addSubview(stack)
        view.backgroundColor = .white

        buttonNext.addTarget(self, action: #selector(goToPlay), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonNext.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 100),
            buttonNext.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -100),
            buttonNext.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func goToPlay() {
        guard dataIsValid() else {
            let alert = UIAlertController(title: "Введены нечисловые значения", message: "Перепроверьте данные", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let postViewController = GameViewController()
        postViewController.groupSize = Int(countPeopleField.text!)
        postViewController.infectionFactor = Int(countInfectedField.text!)
        postViewController.timerInterval = Int(timeRecalculationField.text!)
        
        postViewController.title = "Game"
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func dataIsValid() -> Bool {
        guard isNumber(str: countPeopleField.text) else { return false}
        guard isNumber(str: countInfectedField.text) else { return false}
        guard isNumber(str: timeRecalculationField.text) else { return false}
        
        return true
    }
    
    func isNumber(str: String?) -> Bool {
        guard str != nil else { return false }
        guard str != "" else { return false }
        for el in str! {
            if !el.isNumber {
                return false
            }
        }
        return true
    }
}
