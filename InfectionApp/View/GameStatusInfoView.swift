//
//  GameStatusInfoView.swift
//  InfectionApp
//
//  Created by Danil Antonov on 24.03.2024.
//

import UIKit

class GameStatusInfoView: UIView {
    let infectedCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    let healthyCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .vertical
        stack.backgroundColor = .systemGray
        stack.layer.cornerRadius = 10
        
        return stack
    }()
        
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(infectedCounterLabel)
        stack.addArrangedSubview(healthyCounterLabel)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            infectedCounterLabel.topAnchor.constraint(equalTo: stack.topAnchor),
            infectedCounterLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 20),
            infectedCounterLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -20),
            
            healthyCounterLabel.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
            healthyCounterLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 20),
            healthyCounterLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
