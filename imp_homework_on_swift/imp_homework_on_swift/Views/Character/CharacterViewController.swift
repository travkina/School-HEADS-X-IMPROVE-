//
//  CharacterViewController.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 17.04.2021.
//

import UIKit
import PKHUD
import Alamofire

class CharacterViewController: UIViewController {
    private let reuseIdentifier = "CharacterCell"
    
    let networkService: ListNetworkService = NetworkService()
    var characterListInfo: InfoRespondsModel?
    var characterListArray = [Character]()
    var residentsCount: Int = 0
    var planetName: String = ""
    var characterList: [String] = []
    
    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Жители локации " + planetName
        characterCollectionView.collectionViewLayout = createLayout()
        characterCollectionView.dataSource = self
        characterCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.nibName())
        HUD.allowsInteraction = false
        HUD.dimsBackground = true
        for character in characterList {
            loadCharacters(URL: character)
        }
    }
    
    func loadCharacters(URL: String) {
        HUD.show(.progress)
        AF.request(URL,
                   method: HTTPMethod.get,
                   encoding: JSONEncoding.default).response { (responseData) in
                    guard responseData.error == nil,
                          let data = responseData.data
                    else {
                        print("Error \(responseData.error)")
                        return
                    }
                    HUD.hide()
                    do {
                        let decodedValue: Character = try JSONDecoder().decode(Character.self, from: data)
                        self.characterListArray.append(decodedValue)
                        DispatchQueue.main.async {
                            self.characterCollectionView.reloadData()
                        }
                    }
                    catch (let error) {
                        print("Character: Response parsing error: \(error.localizedDescription)")
                    }
                   }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 20.0
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension CharacterViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characterListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterCollectionViewCell
        
        let characterInfo = self.characterListArray[indexPath.row]
        cell.nameLabel.text = characterInfo.name
        cell.genderLabel.text = characterInfo.gender
        cell.characterImage.loadImage(fromURL: characterInfo.image)
        return cell
    }
}

