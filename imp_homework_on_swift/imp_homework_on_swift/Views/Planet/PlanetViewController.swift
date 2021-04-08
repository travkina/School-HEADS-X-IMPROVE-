//
//  PlanetViewController.swift
//  imp_homework_on_swift
//
//  Created by Студент 1 on 05.04.2021.
//

import UIKit
import PKHUD

class PlanetViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var planetListArray = [PlanetListResultRespondsModel]()
    let networkService: PlanetListNetworkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PlanetTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: PlanetTableViewCell.nibName())
        
        HUD.registerForKeyboardNotifications()
        HUD.allowsInteraction = false
        HUD.dimsBackground = true
        loadPlanets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadPlanets() {
        HUD.show(.progress)
        networkService.getPlanetLits(page: 1) { [weak self] (response, error) in
            guard self == self else { return }
            HUD.hide()
            if let response = response {
                self?.planetListArray = response.results
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
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
}
