//
//  RegistUserDescViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/8/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import Alamofire

struct JoinResponse: Codable {
    let statusCode: String
    let message: String
    let content: JoinData
}

struct JoinData: Codable {
    let id: Int
    let username: String
    let nickname: String
    let imageUrl: String?
    let usageType: String
    let diseaseType: String
    let lifeStyle: String
    let allergy: String
}


class UserPersonalDataViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let viewModel = UserPersonalDataViewModel()
    private var disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.backgroundColor = DesignSystemColor.yorijoriPink
    }
    
    private let contentView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let progressBar = UISlider().then {
        $0.thumbTintColor = .clear
        $0.minimumValue = 0.0
        $0.maximumValue = 1.0
        $0.setValue(0.75, animated: false)
        $0.minimumTrackTintColor = DesignSystemColor.yorijoriPink
        $0.isUserInteractionEnabled = false
    }
    
    private let usageLabel = UILabel().then {
        $0.text = "용도"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private var usageCollectionView: UICollectionView!
    
    private let diseaseLabel = UILabel().then {
        $0.text = "유병 질환"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private var diseaseCollectionView: UICollectionView!
    
    private let lifestyleHabitLabel = UILabel().then {
        $0.text = "생활습관"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private var lifestyleHabitCollectionView: UICollectionView!
    
    private let allergyLabel = UILabel().then {
        $0.text = "알레르기"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.bold16
    }
    
    private lazy var allergyTextField = UITextField().then {
        $0.placeholder = "알레르기를 입력해 주세요"
        $0.layer.cornerRadius = 8
        $0.backgroundColor = DesignSystemColor.gray150
        $0.textColor = DesignSystemColor.gray500
        $0.font = DesignSystemFont.medium14
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.leftViewMode = .always
        $0.returnKeyType = .done
        $0.delegate = self
    }
    
    private lazy var nextButton = UIButton().then {
        $0.backgroundColor = DesignSystemColor.yorijoriPink
        $0.setTitle("다음", for: .normal)
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = DesignSystemFont.semibold16
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupNavigationBar()
        setScrollView()
        setCollectionView()
        setUI()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setScrollView() {
        [scrollView, contentView].forEach({$0.backgroundColor = .white})
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints({
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
        })
    }
    
    private func setCollectionView() {
        let usageCollectionlayout = UICollectionViewFlowLayout()
        usageCollectionlayout.minimumInteritemSpacing = 8
        self.usageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: usageCollectionlayout)
        self.usageCollectionView.delegate = self
        self.usageCollectionView.register(UsageCategoryCell.self, forCellWithReuseIdentifier: UsageCategoryCell.identifier)
        self.usageCollectionView.isScrollEnabled = false
        self.usageCollectionView.isUserInteractionEnabled = true
        
        let diseaseCollectionlayout = UICollectionViewFlowLayout()
        diseaseCollectionlayout.minimumInteritemSpacing = 8
        self.diseaseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: diseaseCollectionlayout)
        self.diseaseCollectionView.delegate = self
        self.diseaseCollectionView.register(DiseaseCategoryCell.self, forCellWithReuseIdentifier: DiseaseCategoryCell.identifier)
        self.diseaseCollectionView.isScrollEnabled = false
        self.diseaseCollectionView.isUserInteractionEnabled = true
        
        let lifestyleHabitCollectionlayout = UICollectionViewFlowLayout()
        lifestyleHabitCollectionlayout.minimumLineSpacing = 16
        self.lifestyleHabitCollectionView = UICollectionView(frame: .zero, collectionViewLayout: lifestyleHabitCollectionlayout)
        self.lifestyleHabitCollectionView.delegate = self
        self.lifestyleHabitCollectionView.register(LifestyleHabitCategoryCell.self, forCellWithReuseIdentifier: LifestyleHabitCategoryCell.identifier)
        self.lifestyleHabitCollectionView.isScrollEnabled = false
        self.lifestyleHabitCollectionView.isUserInteractionEnabled = true
    }
    
    private func setUI() {
        
        [progressBar, usageLabel, usageCollectionView, diseaseLabel, diseaseCollectionView, lifestyleHabitLabel, lifestyleHabitCollectionView, allergyLabel, allergyTextField, nextButton].forEach({self.contentView.addSubview($0)})
        
        progressBar.snp.makeConstraints({
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(4)
        })
        
        usageLabel.snp.makeConstraints({
            $0.top.equalTo(self.progressBar.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(15)
        })
        
        usageCollectionView.snp.makeConstraints({
            $0.top.equalTo(self.usageLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(100)
        })
        
        diseaseLabel.snp.makeConstraints({
            $0.top.equalTo(self.usageCollectionView.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(15)
        })
        
        diseaseCollectionView.snp.makeConstraints({
            $0.top.equalTo(self.diseaseLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(40)
        })
        
        lifestyleHabitLabel.snp.makeConstraints({
            $0.top.equalTo(self.diseaseCollectionView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(15)
        })
        
        lifestyleHabitCollectionView.snp.makeConstraints({
            $0.top.equalTo(self.lifestyleHabitLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(150)
        })
        
        allergyLabel.snp.makeConstraints({
            $0.top.equalTo(self.lifestyleHabitCollectionView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(15)
        })
        
        allergyTextField.snp.makeConstraints({
            $0.top.equalTo(self.allergyLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(46)
        })
        
        nextButton.snp.makeConstraints({
            $0.top.equalTo(self.allergyTextField.snp.bottom).offset(80)
            $0.bottom.equalToSuperview().offset(-30)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(54)
        })
        
        self.scrollView.updateContentSize()
    }
    
    private func bindViewModel() {
        Observable.just(viewModel.usageCategories)
            .bind(to: usageCollectionView.rx.items(cellIdentifier: UsageCategoryCell.identifier, cellType: UsageCategoryCell.self)) { [weak self] index, text, cell in
                guard let self = self else {return}
                cell.button.rx.tap
                    .map { index }
                    .subscribe(onNext: { [weak self] index in
                        self?.viewModel.usageSelectedButtonIndex.accept(index)
                    })
                    .disposed(by: cell.disposeBag)
                
                
                self.viewModel.usageSelectedButtonIndex
                    .map { $0 == index }
                    .subscribe(onNext: { isSelected in
                        cell.configure(text: text, isSelected: isSelected)
                    })
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        Observable.just(viewModel.diseaseCategories)
            .bind(to: diseaseCollectionView.rx.items(cellIdentifier: DiseaseCategoryCell.identifier, cellType: DiseaseCategoryCell.self)) { [weak self] index, text, cell in
                guard let self = self else {return}
                cell.button.rx.tap
                    .map { index }
                    .subscribe(onNext: { [weak self] index in
                        self?.viewModel.diseaseSelectedButtonIndex.accept(index)
                    })
                    .disposed(by: cell.disposeBag)
                
                
                self.viewModel.diseaseSelectedButtonIndex
                    .map { $0 == index }
                    .subscribe(onNext: { isSelected in
                        cell.configure(text: text, isSelected: isSelected)
                    })
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        Observable.just(viewModel.lifestyleHabitCategories)
            .bind(to: lifestyleHabitCollectionView.rx.items(cellIdentifier: LifestyleHabitCategoryCell.identifier, cellType: LifestyleHabitCategoryCell.self)) { [weak self] index, text, cell in
                guard let self = self else {return}
                cell.button.rx.tap
                    .map { index }
                    .subscribe(onNext: { [weak self] index in
                        self?.viewModel.lifestyleSelectedButtonIndex.accept(index)
                    })
                    .disposed(by: cell.disposeBag)
                
                
                self.viewModel.lifestyleSelectedButtonIndex
                    .map { $0 == index }
                    .subscribe(onNext: { isSelected in
                        cell.configure(text: text, isSelected: isSelected)
                    })
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.usageCollectionView {
            let text = viewModel.usageCategories[indexPath.item]
            let textSize = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: DesignSystemFont.semibold14])
            let width = textSize.width + 40
            let height = textSize.height + 20
            return CGSize(width: width, height: height)
        } else if collectionView == self.lifestyleHabitCollectionView {
            return CGSize(width: self.lifestyleHabitCollectionView.frame.width, height: 40)
        } else {
            let text = viewModel.diseaseCategories[indexPath.item]
            let textSize = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: DesignSystemFont.semibold14])
            let width = textSize.width + 40
            let height = textSize.height + 20
            return CGSize(width: width, height: height)
        }
    }
    
    private func getJoinStatus() async throws -> String {
        let requestData: [String: Any] = [
            "username": UserDefaultsManager.shared.id,
            "password": UserDefaultsManager.shared.password,
            "nickname": "요리조리",
            "usageType": "INGREDIENT",
            "diseaseType": "GOUT",
            "lifeStyle": "하루에 3끼 먹어",
            "allergy": "새우"
        ]
        
        do {
            return try await withCheckedThrowingContinuation { continuation in
                NetworkService.shared.postMultipartWithJSON(.join, parameters: requestData) { result in
                    switch result {
                    case .success(let response):
                        continuation.resume(returning: response.statusCode)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } catch {
            await MainActor.run {
                let errorMessage: String
                if let networkError = error as? NetworkError {
                    errorMessage = networkError.localizedDescription
                } else {
                    errorMessage = error.localizedDescription
                }
                
                AlertManager.shared.showAlert(
                    on: self,
                    title: "회원가입 실패",
                    message: errorMessage
                )
            }
            return "Error"
        }
    }
    
    @objc private func nextButtonTapped() {
        Task {
            do {
                let status = try await getJoinStatus()
                if status == "OK" {
                    let lastVC = LastRegisterViewController()
                    lastVC.modalPresentationStyle = .overFullScreen
                    self.navigationController?.pushViewController(lastVC, animated: true)
                } else {
                }
            } catch {
                print("회원가입 실패 \(error)")
            }
        }
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc override func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            let adjustment: CGFloat = keyboardRectangle.height * 0.3
            
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -adjustment)
            }
        }
    }
}

extension UserPersonalDataViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
