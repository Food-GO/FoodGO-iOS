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
        friendsDataSource.append(.init(name: "이름1", currentChallenge: "1,500 kcal", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "이름2", currentChallenge: "단백질 50g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "이름3", currentChallenge: "지방 20g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "이름4", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "name1", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "name2", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "name3", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "name4", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "name5", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "name6", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "name7", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
        friendsDataSource.append(.init(name: "name8", currentChallenge: "단백질 100g", profileImage: UIImage(named: "friend2")))
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
        
        cell.onReTestButtonTap = { [weak self] in
            self?.showPopup(for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend: FriendsListModel
        if isFiltering {
            selectedFriend = filteredFriendsDataSource[indexPath.row]
        } else {
            selectedFriend = friendsDataSource[indexPath.row]
        }
        
        let challengeVC = ChallengeCreationViewController()
        
        // 선택된 친구의 이름만 새 뷰 컨트롤러에 전달합니다.
        challengeVC.friendName = selectedFriend.name
        
        // 새 뷰 컨트롤러로 이동합니다.
        navigationController?.pushViewController(challengeVC, animated: true)
                
    }
    
    private func showPopup(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "친구 신청이 완료되었습니다.", message: "친구가 신청을 수락하면 목록에서 확인할 수 있어요", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.updateCellAppearance(at: indexPath)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateCellAppearance(at indexPath: IndexPath) {
        if let cell = friendListTableView.cellForRow(at: indexPath) as? FriendsListTableViewCell {
            cell.updateButtonAppearance()
        }
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
