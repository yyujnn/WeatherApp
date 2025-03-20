//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by 정유진 on 11/18/24.
//

import UIKit
import SnapKit
import Then

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    private var savedLocations: [String] = ["Seoul", "Incheon", "Busan", "Daegu", "Daejeon", "Gwangju", "Ulsan"]
    
    private var recentSearches: [String] = [] // 최근 검색어
    private var searchResults: [String] = [] // 검색 결과 리스트
    // API 연동 전, 더미 데이터로 검색 필터링
    let allCities = ["Seoul", "Incheon", "Busan", "Daegu", "Daejeon", "Gwangju", "Ulsan"]
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        setupCollectionView()
        setupTableView()
        loadRecentSearches()
    }
    
    private func setupUI() {
        view.backgroundColor = .sunnyBackground
    }
    
    // MARK: - CollectionView 추가된 위치 표시
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
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        }
    }
    
    // MARK: - TableView 검색 결과 표시
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .cloudyPoint1
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        tableView.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func loadRecentSearches() {
        // TODO: Core Data에서 최근 검색어 불러오기
        recentSearches = ["Seoul", "New York", "Tokyo"]
        tableView.reloadData()
    }
    
    // MARK: - SearchController 설정
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city"
        searchController.searchBar.tintColor = .sunnyFont
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - UISearchBarDelegate (검색창 상태)
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        collectionView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        collectionView.isHidden = false
    }
}
// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased(), !query.isEmpty else {
            searchResults.removeAll()
            tableView.reloadData()
            return
        }
        
        searchResults = allCities.filter { $0.lowercased().contains(query) }
        tableView.reloadData()
    }
}
// MARK: - 검색 여부 확인
extension SearchViewController {
    var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
}
// MARK: - UITableView
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isFiltering ? 0 : recentSearches.count // 최근 검색어
        } else {
            return isFiltering ? searchResults.count : 0 // 검색 결과
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // 최근 검색어 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as? RecentSearchCell else {
                return UITableViewCell()
            }
            let location = recentSearches[indexPath.row]
            cell.configure(with: location)
            
            cell.deleteAction = {
                print("\(location) 삭제 (최근 검색)")
                
                // 임시 동작
                self.recentSearches.remove(at: indexPath.row)
                tableView.reloadData()
            }
            return cell
        } else {
            // 검색 결과 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
                return UITableViewCell()
            }
            cell.configure(with: searchResults[indexPath.row])
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // 최근 검색어 셀
            let selectedCity = recentSearches[indexPath.row]
            print("\(selectedCity) 선택 (최근 검색어)")
            
            // 선택한 도시를 저장된 위치에 추가
            if !savedLocations.contains(selectedCity) {
                savedLocations.append(selectedCity)
                collectionView.reloadData()
            }
        } else {
            // 검색 결과 셀
            let selectedCity = searchResults[indexPath.row]
            print("\(selectedCity) 선택 (검색 결과)")
            
            // 선택한 도시를 저장된 위치에 추가
            if !savedLocations.contains(selectedCity) {
                savedLocations.append(selectedCity)
                collectionView.reloadData()
            }
        }
        // TODO: WeatherPreviewVC 화면 이동
        searchController.searchBar.text = ""
        searchController.isActive = false
        tableView.isHidden = true
        collectionView.isHidden = false // 검색 후 컬렉션뷰 보이기
    }
}
// MARK: - UICollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedLocationCell.identifier, for: indexPath) as? SavedLocationCell else { return UICollectionViewCell() }
        
        let text = savedLocations[indexPath.row]
        cell.configure(location: text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = savedLocations[indexPath.row]
        print("선택한 항목: \(selectedItem)")
    }
}
