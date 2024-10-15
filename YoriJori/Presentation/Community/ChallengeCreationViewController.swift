//
//  ChallengeCreationViewController.swift
//  YoriJori
//
//  Created by 김강현 on 10/12/24.
//

import UIKit
import SnapKit

class ChallengeCreationViewController: UIViewController {
    
    var friendName = ""
    
    private let nameBGView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = DesignSystemColor.white
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "friend2")
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(friendName)"
        label.font = DesignSystemFont.bold14
        label.textColor = DesignSystemColor.gray900
        return label
    }()
    
    private let dateBGView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = DesignSystemColor.white
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "목표 날짜"
        label.font = DesignSystemFont.bold16
        label.textColor = DesignSystemColor.gray900
        return label
    }()
    
    private let datePicker: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 37
        return stack
    }()
    
    private let yearTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "2024"
        textField.textAlignment = .center
        textField.backgroundColor = DesignSystemColor.gray150
        textField.layer.cornerRadius = 12
        textField.textColor = DesignSystemColor.gray500
        return textField
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "년"
        label.font = DesignSystemFont.bold14
        label.textColor = DesignSystemColor.gray800
        return label
    }()
    
    private let monthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "8"
        textField.textAlignment = .center
        textField.backgroundColor = DesignSystemColor.gray150
        textField.layer.cornerRadius = 12
        textField.textColor = DesignSystemColor.gray500
        return textField
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        label.font = DesignSystemFont.bold14
        label.textColor = DesignSystemColor.gray800
        return label
    }()
    
    private let dayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "25"
        textField.textAlignment = .center
        textField.backgroundColor = DesignSystemColor.gray150
        textField.textColor = DesignSystemColor.gray500
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        label.font = DesignSystemFont.bold14
        label.textColor = DesignSystemColor.gray800
        return label
    }()
    
    private let challengeBGView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = DesignSystemColor.white
    }
    
    private let challengeLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 목표"
        label.font = DesignSystemFont.bold16
        label.textColor = DesignSystemColor.gray900
        return label
    }()
    
    private let challengeTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("탄수화물", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(DesignSystemColor.gray800, for: .normal)
        button.backgroundColor = DesignSystemColor.white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = DesignSystemColor.gray150.cgColor
        return button
    }()
    
    private let goalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.textAlignment = .center
        textField.backgroundColor = DesignSystemColor.gray150
        textField.textColor = DesignSystemColor.gray500
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.text = "g"
        label.font = DesignSystemFont.medium14
        label.textColor = DesignSystemColor.gray800
        return label
    }()
    
    private let createButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "챌린지 신청하기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupNavigationBar() {
        self.title = "챌린지 신청"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = DesignSystemColor.gray900
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupUI() {
        view.backgroundColor = DesignSystemColor.gray100
        
        [nameBGView, dateBGView, challengeBGView, createButton].forEach { view.addSubview($0) }
        
        [profileImageView, nameLabel].forEach({self.nameBGView.addSubview($0)})
        [dateLabel, datePicker, yearLabel, monthLabel, dayLabel].forEach({self.dateBGView.addSubview($0)})
        [yearTextField, monthTextField, dayTextField].forEach({self.datePicker.addArrangedSubview($0)})
        [challengeLabel, challengeTypeButton, goalTextField, unitLabel].forEach({self.challengeBGView.addSubview($0)})
        
        nameBGView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(76)
        })
        
        profileImageView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
            $0.width.height.equalTo(48)
        })
        
        nameLabel.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(8)
        })
        
        dateBGView.snp.makeConstraints({
            $0.top.equalTo(self.nameBGView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(105)
        })
        
        dateLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(14)
        })
        
        datePicker.snp.makeConstraints({
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(45)
        })
        
        yearLabel.snp.makeConstraints({
            $0.centerY.equalTo(self.yearTextField.snp.centerY)
            $0.leading.equalTo(self.yearTextField.snp.trailing).offset(8)
        })
        
        monthLabel.snp.makeConstraints({
            $0.centerY.equalTo(self.monthTextField.snp.centerY)
            $0.leading.equalTo(self.monthTextField.snp.trailing).offset(8)
        })
        
        dayLabel.snp.makeConstraints({
            $0.centerY.equalTo(self.dayTextField.snp.centerY)
            $0.leading.equalTo(self.dayTextField.snp.trailing).offset(8)
        })
        
        challengeBGView.snp.makeConstraints({
            $0.top.equalTo(self.dateBGView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(106)
        })
        
        challengeLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(14)
        })
        
        challengeTypeButton.snp.makeConstraints({
            $0.top.equalTo(self.challengeLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(14)
            $0.width.equalTo(158)
            $0.height.equalTo(46)
        })
        
        goalTextField.snp.makeConstraints({
            $0.top.equalTo(self.challengeLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-14)
            $0.width.equalTo(158)
            $0.height.equalTo(46)
        })
        
        unitLabel.snp.makeConstraints({
            $0.centerY.equalTo(self.goalTextField.snp.centerY)
            $0.trailing.equalTo(self.goalTextField.snp.trailing).offset(-12)
        })
        
        createButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-50)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
