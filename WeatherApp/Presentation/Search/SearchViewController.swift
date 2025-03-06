//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by 정유진 on 11/18/24.
//

import UIKit
import Then

class SearchViewController: UIViewController {
    
    private var data = ["seoul", "incheon", "busan", "서울", "인천", "부신", "대구", "대전", "광주", "제주"]
    private var filteredData: [String] = []
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        tableView.frame  = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchCell.self,
                           forCellReuseIdentifier: SearchCell.identifier)
        view.addSubview(tableView)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredData.count : data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UITableViewCell() }
        let text = isFiltering ? filteredData[indexPath.row] : data[indexPath.row]
        cell.configure(with: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = isFiltering ? filteredData[indexPath.row] : data[indexPath.row]
        print("선택한 항목: \(selectedItem)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredData = []
            tableView.reloadData()
            return
        }
        
        filteredData = data.filter { $0.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

// MARK: - 검색 여부 확인
extension SearchViewController {
    var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
}
