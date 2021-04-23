//
//  PlanetViewController.swift
//  imp_homework_on_swift
//
//  Created by Студент 1 on 05.04.2021.
//

import UIKit
import PKHUD
import Alamofire

class PlanetViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let networkService: ListNetworkService = NetworkService()
    var planetListInfo: InfoRespondsModel?
    var planetListArray = [Planet]()
    var scroll: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PlanetTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: PlanetTableViewCell.nibName())
        
        HUD.registerForKeyboardNotifications()
        HUD.allowsInteraction = false
        HUD.dimsBackground = true
        loadPlanets(URL: NetworkConstants.URLString.planetList + "?page=\(1)")
    }
    
    func loadPlanets(URL: String) {
        HUD.show(.progress)
        DispatchQueue.global().async {
            self.networkService.getPlanetLits(URL: URL) { [weak self] (response, error) in
                guard self == self else { return }
                HUD.hide()
                if let response = response {
                    self?.planetListInfo = response.info
                    self?.planetListArray += response.results
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    deinit {
        HUD.deregisterFromKeyboardNotifications()
    }
}
extension PlanetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.planetListArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlanetTableViewCell.nibName(), for: indexPath) as? PlanetTableViewCell {
            let planetInfo = self.planetListArray[indexPath.row]
            cell.LocationLabel.text = planetInfo.name
            cell.TypeLocationLabel.text = planetInfo.type
            cell.PopulationLabel.text = planetInfo.residents.count.description
            return cell
        }
        return UITableViewCell()
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
         let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
         if let characterViewController = mainStoryBoard.instantiateViewController(identifier: "CharacterVC") as? CharacterViewController {
            let planetInfo = self.planetListArray[indexPath.row]
            characterViewController.characterList = planetInfo.residents
            characterViewController.planetName = planetInfo.name
            characterViewController.residentsCount = planetInfo.residents.count
            navigationController?.pushViewController(characterViewController, animated: true)
         }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yposition = scrollView.contentOffset.y
        
        if yposition > (scrollView.contentSize.height - scrollView.frame.size.height)
       {
            if let url = planetListInfo?.next {
                loadPlanets(URL: url)
            } else {
                return
            }
        }
    }
}
