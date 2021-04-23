//
//  CharacterViewController.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 17.04.2021.
//

import UIKit
import PKHUD
import Alamofire

var characterDictionary = Dictionary<String, CharacterInfo>(minimumCapacity: 671)

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
        
        DispatchQueue.global().async {
            for character in self.characterList {
                self.loadCharacters(URL: character)
            }
        }
    }
    func getCharacter(URL:String, onRequestComleted: @escaping ((Character?, Error?) -> ())) {
        self.networkService.getByUrl(urlString: URL, onRequestComleted: onRequestComleted)
    }
    func loadCharacters(URL: String) {
        DispatchQueue.global().async {
            self.getCharacter(URL: URL) { [weak self] (response, error) in
                guard self == self else {return}
                if let response = response {
                    self?.characterListArray.append(response)
                    self?.networkService.getCharacterImage(url: response.image) { [weak self] (responseData, error) in
                        guard self == self else { return }
                        if let responseData = responseData {
                            let characterInformation = CharacterInfo(name: response.name, gender: response.gender, picture: responseData)
                            // MARK: PLEASE HELP!
                            characterDictionary = [response.url: characterInformation]
                            characterDictionary[response.url] = characterInformation
                           
                                if ((characterDictionary.isEmpty) != nil) {
                                    print(" characterDictionary is empty.")
                                } else {
                                    if let characterName = characterDictionary[response.url] {
                                        print("The characterDictionary isn't empty. Name = \(characterName.name)")
                                    }
                                }
                            //////////////////////////////////////////////////////
                            }
                    }
                    DispatchQueue.main.async {
                        self?.characterCollectionView.reloadData()
                    }
                }
            }
        }
    }
    func resizedImage(image: UIImage, for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
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
        // MARK: PLEASE HELP!
        /* if characterDictionary.isEmpty {
            print("The characterDictionary is empty.")
        } else {
            if let characterData = characterDictionary[characterInfo.url] {
                print("The characterDictionary isn't empty. Name = \(characterData.name)")
                cell.nameLabel.text = characterData.name
                cell.genderLabel.text = characterData.gender
                if let picture = characterData.picture {
                    DispatchQueue.main.async {
                        cell.characterImage.image = UIImage(data: picture)//self.resizedImage(image: , for: CGSize(width: 200.0, height: 200.0))
                    }
                }
            }
        }
         */
        //it work
        cell.nameLabel.text = characterInfo.name
        cell.genderLabel.text = characterInfo.gender
        DispatchQueue.global().async {
            self.networkService.getCharacterImage(url: characterInfo.image) { [weak self] (response, error) in
                guard self == self else { return }
                if let response = response {
                    DispatchQueue.main.async {
                        cell.characterImage.image = self?.resizedImage(image: response, for: CGSize(width: 200.0, height: 200.0))
                    }
                }
            }
        }
        return cell
    }
}
