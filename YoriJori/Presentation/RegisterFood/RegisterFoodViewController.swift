//
//  RegisterFoodViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/26/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Alamofire

class RegisterFoodViewController: UIViewController {
    
    var foodItems: [FoodList] = [] {
        didSet {
            isFoodListEmpty = foodItems.isEmpty
            tableView.reloadData()
            updateUI()
        }
    }
    
    var isFoodListEmpty: Bool = true {
        didSet {
            updateUI()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private let foodNotExistLabel = UILabel().then {
        $0.text = "아직 등록된 식재료가 없어요"
        $0.font = DesignSystemFont.regular14
        $0.textColor = DesignSystemColor.gray600
    }
    
    private let addFoodButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "식재료 추가하기 +"
    }
    
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.white
        self.tabBarController?.tabBar.isHidden = true
        setupNavigationBar()
        setupTableView()
        setupViews()
        updateUI()
        bindAddFoodButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            do {
                let foodList = try await getFoodList()
                print("받은 음식 목록: \(foodList)")
                if foodList.isEmpty {
                    
                } else {
                    self.foodItems = foodList
                }
            } catch {
                print("오류 발생: \(error)")
            }
        }
    }
    
    private func setupNavigationBar() {
        self.title = "내 식재료"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
        
        let editButton = UIBarButtonItem(title: "편집", style: .done, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = DesignSystemColor.gray600
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func setupViews() {
        [foodNotExistLabel, addFoodButton, tableView].forEach({self.view.addSubview($0)})
        
        foodNotExistLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        addFoodButton.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.addFoodButton.snp.top).offset(-23)
        })
    }
    
    private func updateUI() {
        foodNotExistLabel.isHidden = !isFoodListEmpty
        tableView.isHidden = isFoodListEmpty
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(IngredientTableCell.self, forCellReuseIdentifier: "IngredientTableCell")
    }
    
    private func bindAddFoodButton() {
        addFoodButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showBottomSheet()
            })
            .disposed(by: disposeBag)
    }
    
    private func showBottomSheet() {
        let bottomSheet = AddFoodBottomSheetViewController()
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        bottomSheet.optionSelected
            .subscribe(onNext: { [weak self] option in
                self?.handleSelectedOption(option)
                bottomSheet.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        present(bottomSheet, animated: true, completion: nil)
    }
    
    private func handleSelectedOption(_ option: String) {
        switch option {
        case "recognize":
            print("식재료 인식 선택됨")
            // 여기에 식재료 인식 로직 구현
        case "manual":
            print("직접 작성하기 선택됨")
            let vc = ManualAddFoodViewController()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    private func getFoodList() async throws -> [FoodList] {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaultsManager.shared.accesstoken)"
        ]
        print("헤더 \(header)")
        
        return try await withCheckedThrowingContinuation { continuation in
            NetworkService.shared.get(.cuisine, headers: header) { (result: Result<FoodResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    print("결과값 \(response)")
                    continuation.resume(returning: response.content)
                case .failure(let error):
                    print("실패 \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func editButtonTapped() {
        
    }
    
}

extension RegisterFoodViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableCell.identifier, for: indexPath) as? IngredientTableCell else {
            return UITableViewCell()
        }
        
        let ingredient = foodItems[indexPath.row]
        cell.configure(with: ingredient)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
