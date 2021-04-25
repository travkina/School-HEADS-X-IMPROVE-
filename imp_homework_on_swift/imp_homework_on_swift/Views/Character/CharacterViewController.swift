//
//  CharacterViewController.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 17.04.2021.
//
import Foundation
import UIKit
import Alamofire

var characterDictionary = Dictionary<String, CharacterInfo>(minimumCapacity: 671)

class CharacterViewController: UIViewController {
    private let reuseIdentifier = "CharacterCell"
    
    let networkService: ListNetworkService = NetworkService()
    var characterListInfo: InfoRespondsModel?
    var characterListArray = [Character]()
    var characterSequence: [CharacterInfo]=[]
    var characterDict: [String : CharacterInfo] = [:]
    var residentsCount: Int = 0
    var planetName: String = ""
    var characterList: [String] = []
    
    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Жители локации " + planetName
        characterCollectionView.collectionViewLayout = createLayout()
        characterCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.nibName())
        characterCollectionView.dataSource = self
        self.loadCharacters(URLS: self.characterList)
    }

   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if characterDictionary.isEmpty {
            characterDictionary = Dictionary(uniqueKeysWithValues: zip(self.characterList, self.characterSequence))
        } else {
            self.characterDict = Dictionary(uniqueKeysWithValues: zip(self.characterList, self.characterSequence))
            characterDictionary.merge(self.characterDict) {(current, _) in current}
        }
        DispatchQueue.main.async {
            self.characterCollectionView.reloadData()
        }
    }
    
    func getCharacter(URL:String, onRequestComleted: @escaping ((Character?, Error?) -> ())) {
        self.networkService.getByUrl(urlString: URL, onRequestComleted: onRequestComleted)
    }
    
    func loadCharacters(URLS: [String]) {
        DispatchQueue.global().async {
            for URL in URLS {
                if !characterDictionary.keys.contains(URL) {
                    self.getCharacter(URL: URL) { [weak self] (response, error) in
                        guard self == self else {return}
                        if let response = response {
                            self?.characterListArray.append(response)
                            self?.networkService.getCharacterImage(url: response.image) { [weak self] (responseData, error) in
                                guard self == self else { return }
                                if let responseData = responseData {
                                    let characterInformation = CharacterInfo(name: response.name, gender: response.gender, picture: responseData)
                                    self?.characterSequence.append(characterInformation)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadCharacter(URL: String) {
       DispatchQueue.global().async {
            self.getCharacter(URL: URL) { [weak self] (response, error) in
                guard self == self else {return}
                if let response = response {
                    var characterInformation = CharacterInfo(name: response.name, gender: response.gender)
                    characterDictionary[URL] = characterInformation
                    self?.networkService.getCharacterImage(url: response.image) { [weak self] (responseData, error) in
                        guard self == self else { return }
                        if let responseData = responseData {
                            characterInformation.picture = responseData
                            characterInformation.miniPicture = self?.resizedImage(image: responseData, for: CGSize(width: 120, height: 120)) ?? UIImage(named: "ph")!
                            self?.characterSequence.append(characterInformation)
                            characterDictionary[URL] = characterInformation
                        }
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
        return self.characterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CharacterCollectionViewCell {
            let url = self.characterList[indexPath.row]
            cell.activityIndicator.startAnimating()
            cell.activityIndicator.hidesWhenStopped = true

            if !characterDictionary.keys.contains(url) {
                loadCharacter(URL: url)
                DispatchQueue.main.async {
                    if let characterData = characterDictionary[url] {
                        
                        cell.nameLabel.text = characterData.name
                        cell.genderLabel.text = characterData.gender
                        cell.activityIndicator.stopAnimating()
                    }
                }
                DispatchQueue.main.async {
                   if let characterData = characterDictionary[url] {
                        
                        cell.characterImage.image = characterData.picture
                        cell.activityIndicator.stopAnimating()
                    }
                }
                
            } else {
                guard let characterData = characterDictionary[url] else {return cell}
                    cell.activityIndicator.stopAnimating()
                    cell.nameLabel.text = characterData.name
                    cell.genderLabel.text = characterData.gender
                    cell.characterImage.image = characterData.picture
            }
            
            return cell
            
        }
        return UICollectionViewCell()
    }
}
