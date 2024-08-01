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

class RegisterFoodViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let foodNotExistLabel = UILabel().then {
        $0.text = "아직 등록된 식재료가 없어요"
        $0.font = DesignSystemFont.regular14
        $0.textColor = DesignSystemColor.gray600
    }
    
    private let addFoodButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "식재료 추가하기 +"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.white
        self.tabBarController?.tabBar.isHidden = true
        setupNavigationBar()
        setUI()
        bindAddFoodButton()
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
    
    private func setUI() {
        [foodNotExistLabel, addFoodButton].forEach({self.view.addSubview($0)})
        
        foodNotExistLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        addFoodButton.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
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
            // 여기에 직접 작성하기 로직 구현
        default:
            break
        }
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func editButtonTapped() {
        
    }
    
}
