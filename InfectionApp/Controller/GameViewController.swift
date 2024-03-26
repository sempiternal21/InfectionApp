//
//  ViewController.swift
//  InfectionApp
//
//  Created by Danil Antonov on 24.03.2024.
//

import UIKit

class GameViewController: UIViewController {
    
    var infectionFactor: Int!
    var timerInterval: Int!
    var groupSize: Int!
    
    private var collectionView: UICollectionView!
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    private let gameStatusInfoView = GameStatusInfoView()
    private let cellIdentifier = "cell"
    
    private var peoples: [Int]!
    private var timer: Timer!
    private var infectedCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        peoples = Array(repeating: 0, count: groupSize)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: configureCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(gameStatusInfoView)
        
        updateScore()
        configureMainUI()
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.startTimer()
        }
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: Double(self.timerInterval), target: self, selector: #selector(self.action), userInfo: nil, repeats: true)
        RunLoop.current.run()
    }
    
    @objc func action() {
        var infectedPeoples: Set<IndexPath> = []
        for i in 0..<peoples.count {
            if peoples[i] == 1 {
                let indexPath = IndexPath(row: i, section: 0)
                infectedPeoples.insert(indexPath)
            }
        }
        infectedCount = infectedPeoples.count
        
        var newInfectedPeoples: Set<IndexPath> = []
        for infectedPeople in infectedPeoples {
            let indexPath = infectedPeople
            var neighbours = getNeighbours(indexPath: indexPath).shuffled()
            var randomInt = Int.random(in: 0...infectionFactor)
            randomInt = randomInt > neighbours.count ? neighbours.count : randomInt
            neighbours = Array(neighbours[0..<randomInt])
            for i in neighbours {
                newInfectedPeoples.insert(i)
            }
        }
        
        for newInfectedPeople in newInfectedPeoples {
            if peoples[newInfectedPeople.row] == 0 {
                peoples[newInfectedPeople.row] = 1
                infectedCount += 1
            }
            DispatchQueue.main.async {
                self.updateScore()
                guard let cell = self.collectionView.cellForItem(at: newInfectedPeople) else { return }
                cell.backgroundColor = .red
                
                self.checkEndGame()
            }
        }
    }
    
    func getNeighbours(indexPath: IndexPath) -> [IndexPath] {
        let row = indexPath.row
        var neighbours: [IndexPath] = []
        if (row - 10 >= 0) {
            neighbours.append(IndexPath(row: row - 10, section: 0))
        }
        if (row + 10 < self.peoples.count) {
            neighbours.append(IndexPath(row: row + 10, section: 0))
        }
        if (row - 1 >= 0 && row % 10 != 0) {
            neighbours.append(IndexPath(row: row - 1, section: 0))
        }
        if (row + 1 < self.peoples.count && row % 10 != 9) {
            neighbours.append(IndexPath(row: row + 1, section: 0))
        }
        if (row - 11 >= 0 && row % 10 != 0) {
            neighbours.append(IndexPath(row: row - 11, section: 0))
        }
        if (row + 11 < self.peoples.count && row % 10 != 9) {
            neighbours.append(IndexPath(row: row + 11, section: 0))
        }
        if (row - 9 >= 0 && row % 10 != 0 && row % 10 != 9) {
            neighbours.append(IndexPath(row: row - 9, section: 0))
        }
        if (row + 9 < self.peoples.count && row % 10 != 0) {
            neighbours.append(IndexPath(row: row + 9, section: 0))
        }
        
        return neighbours
    }
    
    func checkEndGame() {
        if (self.peoples.count == self.peoples.reduce(0, +)) {
            self.timer.invalidate()
            let alert = UIAlertController(title: "Игра окончена!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.bounds.width / 10) - 2, height: (view.bounds.width / 10) - 2)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 1
        
        return layout
    }
    
    func configureMainUI() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gameStatusInfoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            gameStatusInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameStatusInfoView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func updateScore() {
        self.gameStatusInfoView.infectedCounterLabel.text = "Больных: \(self.infectedCount)"
        self.gameStatusInfoView.healthyCounterLabel.text = "Здоровых: \(self.peoples.count - self.infectedCount)"
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = .red
        peoples[indexPath.row] = 1
        infectedCount += 1
        updateScore()
        checkEndGame()
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peoples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        if peoples[indexPath.row] == 0 {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .red
        }
        
        return cell
    }
}
