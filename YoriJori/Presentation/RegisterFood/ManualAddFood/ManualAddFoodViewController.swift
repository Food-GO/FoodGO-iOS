//
//  ManualAddFoodViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ManualAddFoodViewController: UIViewController {
    
    private let viewModel = ManualAddFoodViewModel()
    private let disposeBag = DisposeBag()
    
    private let photoView = UIImageView().then {
        $0.backgroundColor = DesignSystemColor.gray150
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let emptyPhotoImageView = UIImageView().then {
        $0.image = UIImage(named: "empty_photo")
    }
    
    private let photoImageBottomDivider = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private let foodNameLabel = UILabel().then {
        $0.text = "식재료명"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.title3
    }
    
    private let foodTextField = YorijoriTextField().then {
        $0.placeholder = "식재료 명을 입력해주세요"
    }
    
    private let foodTextFieldBottomDivider = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray150
    }
    
    private let countLabel = UILabel().then {
        $0.text = "수량"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.title3
    }
    
    private let countSelectorStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 9
    }
    
    private let countView = CounterView()
    
    private let unitSelectorView = UnitSelectorView()
    
    private let nextButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "완료"
        $0.isDisabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DesignSystemColor.white
        
        setupNavigationBar()
        setUI()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        self.title = "식재료 추가"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    private func setUI() {
        [photoView, photoImageBottomDivider, foodNameLabel, foodTextField, foodTextFieldBottomDivider, countLabel, countSelectorStackView, nextButton].forEach({self.view.addSubview($0)})
        self.photoView.addSubview(emptyPhotoImageView)
        [countView, unitSelectorView].forEach({self.countSelectorStackView.addArrangedSubview($0)})
        
        let tapGesture = UITapGestureRecognizer()
        photoView.addGestureRecognizer(tapGesture)
        photoView.isUserInteractionEnabled = true
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.presentImagePicker()
            })
            .disposed(by: disposeBag)
        
        photoView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(260)
        })
        
        emptyPhotoImageView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalTo(40)
        })
        
        photoImageBottomDivider.snp.makeConstraints({
            $0.top.equalTo(self.photoView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        })
        
        foodNameLabel.snp.makeConstraints({
            $0.top.equalTo(self.photoImageBottomDivider.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(18)
        })
        
        foodTextField.snp.makeConstraints({
            $0.top.equalTo(self.foodNameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(46)
        })
        
        foodTextFieldBottomDivider.snp.makeConstraints({
            $0.top.equalTo(self.foodTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        })
        
        countLabel.snp.makeConstraints({
            $0.top.equalTo(self.foodTextFieldBottomDivider.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(18)
        })
        
        countSelectorStackView.snp.makeConstraints({
            $0.top.equalTo(self.countLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(46)
        })
        
        countView.snp.makeConstraints({
            $0.width.equalTo(248)
        })
        
        nextButton.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
        
    }
    
    private func bindViewModel() {
        foodTextField.rx.text.orEmpty
            .bind(to: viewModel.foodName)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.backButtonTapped()
            })
            .disposed(by: disposeBag)
        
        viewModel.photoImage
            .bind(to: photoView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.isNextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.photoImage
            .map { $0 != nil }
            .bind(to: emptyPhotoImageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        emptyPhotoImageView.isHidden = false
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ManualAddFoodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.setPhoto(image)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
