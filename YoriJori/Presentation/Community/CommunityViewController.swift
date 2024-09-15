//
//  CommunityViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit
import SnapKit

class CommunityViewController: UIViewController {
    
    private var friendsDataSource = [FriendsListModel]()
    
    private var filteredFriendsDataSource = [FriendsListModel]()
    
    var isFiltering: Bool {
       return searchBar.text?.isEmpty == false
    }
    
    private lazy var searchBar = UISearchBar().then {
        $0.placeholder = "아이디를 검색해 주세요"
        $0.searchTextField.backgroundColor = DesignSystemColor.white
        $0.searchTextField.layer.cornerRadius = 23
        $0.backgroundColor = UIColor.clear
        $0.delegate = self
    }
    
    private let friendLabel = UILabel().then {
        $0.text = "친구"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.semibold16
    }
    
    private lazy var friendListTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = DesignSystemColor.gray150
        $0.register(FriendsListTableViewCell.self, forCellReuseIdentifier: FriendsListTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.gray150
        
        setupNavigationBar()
        setUI()
        loadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUI() {
        [searchBar, friendLabel, friendListTableView].forEach({self.view.addSubview($0)})
        
        searchBar.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(46)
        })
        
        friendLabel.snp.makeConstraints({
            $0.top.equalTo(self.searchBar.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(18)
        })
        
        friendListTableView.snp.makeConstraints({
            $0.top.equalTo(self.friendLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        })
    }
    
    private func loadData() {
        friendsDataSource.append(.init(name: "칼로리", currentChallenge: "1,500 kcal", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "단백질", currentChallenge: "단백질 50g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "이름", currentChallenge: "지방 20g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "지방", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "지방2", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "kcal", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "fat", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "name", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "Name", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "Fat", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "protein", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "Protein", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
    }
    
}

extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isFiltering {
            return filteredFriendsDataSource.count
        } else {
            return friendsDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsListTableViewCell.identifier) as? FriendsListTableViewCell ?? FriendsListTableViewCell()
        
        if self.isFiltering {
            cell.bind(model: filteredFriendsDataSource[indexPath.row])
        } else {
            cell.bind(model: friendsDataSource[indexPath.row])
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

extension CommunityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredFriendsDataSource = friendsDataSource
        } else {
            filteredFriendsDataSource = friendsDataSource.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        friendListTableView.reloadData()
    }
}
