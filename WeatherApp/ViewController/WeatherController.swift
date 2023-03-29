//
//  WeatherController.swift
//  WeatherApp
//
//  Created by Prateek on 27/03/23.
//

import UIKit

class WeatherController: UITableViewController {
    
    
    var weatherInfo = [Weather]()  {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let viewModel = WeatherViewModel()

    // MARK: - View Life Cycle Mehtods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onGetResponse = { [weak self] response in
                self?.weatherInfo = response
        }
        viewModel.onGetError = { [weak self] error in
            self?.showErrorMessage()
        }
        
        //Call this method on search button
        
        addSearchView()
    }
    
    // MARK: - Private Mehtods
    
    private func addSearchView() {
        
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Search City"
        self.navigationItem.searchController = search
    }
    
    private func showErrorMessage() {
        clearData()
        let alert = UIAlertController(title: "", message: "Data not found", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    private func clearData() {
        //We can do any addtional setup like show empty view(with error message)
        weatherInfo = []
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return weatherInfo.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.city ?? ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellID, for: indexPath)
        let modle = weatherInfo[indexPath.row]
        cell.textLabel?.text = modle.description

        return cell
    }

}

// MARK: - UISearchControllerDelegate Mehtods

extension WeatherController: UISearchControllerDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearData()
    }
}

// MARK: - UISearchBarDelegate Mehtods

extension WeatherController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchCity = searchBar.text,!searchCity.isEmpty else {
            clearData()
            return
        }
        viewModel.loadWeatherData(for: searchCity)
    }

}

