//
//  FriendsListTableViewCell.swift
//  YoriJori
//
//  Created by 김강현 on 9/14/24.
//

import UIKit
import SnapKit

class FriendsListTableViewCell: UITableViewCell {
    
    var onReTestButtonTap: (() -> Void)?
    
    static let identifier = "FriendsListTableViewCell"
    
    private let container = UIView().then {
        $0.backgroundColor = DesignSystemColor.white
        $0.layer.cornerRadius = 12
    }
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "friend2")
        $0.layer.cornerRadius = 24
    }
    
    private let nameLabel = UILabel().then {
        $0.font = DesignSystemFont.bold14
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let currentDoneChallengeTitle = UILabel().then {
        $0.text = "최근 달성 챌린지"
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.semibold12
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = DesignSystemColor.gray400
    }
    
    private let currentDoneChallengeLabel = UILabel().then {
        $0.textColor = DesignSystemColor.gray900
        $0.font = DesignSystemFont.medium12
    }
    
    private lazy var reTestButton: YorijoriFilledButton = {
        let button = YorijoriFilledButton(bgColor: DesignSystemColor.gray150, textColor: DesignSystemColor.gray800)
        button.text = "친구 신청"
        button.addTarget(self, action: #selector(reTestButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = DesignSystemColor.gray150
        self.selectionStyle = .none
        self.addSubview(container)
        
        self.contentView.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true
        
        container.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        })
        
        [profileImage, nameLabel, currentDoneChallengeTitle, divider, currentDoneChallengeLabel, reTestButton].forEach({self.container.addSubview($0)})
        
        profileImage.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(48)
        })
        
        nameLabel.snp.makeConstraints({
            $0.top.equalTo(self.profileImage.snp.top).offset(2.5)
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(8)
        })
        
        currentDoneChallengeTitle.snp.makeConstraints({
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(8)
        })
        
        divider.snp.makeConstraints({
            $0.centerY.equalTo(self.currentDoneChallengeTitle.snp.centerY)
            $0.leading.equalTo(self.currentDoneChallengeTitle.snp.trailing).offset(4)
            $0.width.equalTo(2)
            $0.height.equalTo(14)
        })
        
        currentDoneChallengeLabel.snp.makeConstraints({
            $0.leading.equalTo(self.divider.snp.trailing).offset(4)
            $0.centerY.equalTo(self.currentDoneChallengeTitle.snp.centerY)
        })
        
        reTestButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-18)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(89)
            $0.height.equalTo(29)
        })
        
        self.container.bringSubviewToFront(reTestButton)
    }
    
    @objc private func reTestButtonTapped() {
        print("Button tapped!")
        onReTestButtonTap?()
    }
    
    func updateButtonAppearance() {
        reTestButton.backgroundColor = DesignSystemColor.yorijoriGreen
        reTestButton.setTextColor(DesignSystemColor.white)
        reTestButton.text = "친구 신청됨"
        reTestButton.layer.cornerRadius = 12
        reTestButton.isEnabled = false
    }
}

extension FriendsListTableViewCell {
    public func bind(model: FriendsListModel) {
        nameLabel.text = model.name
        currentDoneChallengeLabel.text = model.currentChallenge
    }
}
