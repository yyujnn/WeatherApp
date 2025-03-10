//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by 정유진 on 11/18/24.
//

import UIKit
import SnapKit
import Then

class SearchViewController: UIViewController {
    
    private var data = ["seoul", "incheon"]
    private var filteredData: [String] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        setupCollectionView()
    }
    
    private func setupUI() {
        view.backgroundColor = .sunnyBackground
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 130)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .sunnyBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SavedLocationCell.self, forCellWithReuseIdentifier: SavedLocationCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {             
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city"
        searchController.searchBar.tintColor = .sunnyFont
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? filteredData.count : data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedLocationCell.identifier, for: indexPath) as? SavedLocationCell else { return UICollectionViewCell() }
        
        let text = isFiltering ? filteredData[indexPath.row] : data[indexPath.row]
        cell.configure(location: text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = isFiltering ? filteredData[indexPath.row] : data[indexPath.row]
        print("선택한 항목: \(selectedItem)")
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredData = []
            collectionView.reloadData()
            return
        }
        
        filteredData = data.filter { $0.lowercased().contains(searchText.lowercased()) }
        collectionView.reloadData()
    }
}

// MARK: - 검색 여부 확인
extension SearchViewController {
    var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
}
