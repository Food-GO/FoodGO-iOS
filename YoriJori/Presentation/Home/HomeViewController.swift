//
//  HomeViewController.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit
import SnapKit
import ARKit
import RxSwift
import RxCocoa
import Alamofire

// MARK: - Response Model
struct DetectionResponse: Codable {
    let rawResults: [DetectionResult]
    
    enum CodingKeys: String, CodingKey {
        case rawResults = "raw_results"
    }
}

struct DetectionResult: Codable {
    let name: String
}


class HomeViewController: UIViewController, ARSCNViewDelegate {
    
    private let sceneView = ARSCNView()
    
    private let disposeBag = DisposeBag()
    
    private let logo = UIImageView().then {
        $0.image = UIImage(named: "small_logo")
    }
    
    private let bottomSheetview = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = DesignSystemColor.white
        $0.layer.borderColor = DesignSystemColor.gray150.cgColor
        $0.layer.borderWidth = 1
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let recognizeDescLabel = UILabel().then {
        $0.text = "식재료를 인식해 보세요!"
        $0.font = DesignSystemFont.bold18
        $0.textColor = DesignSystemColor.gray900
    }
    
    private let recognizeButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "식재료 인식하기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        sceneView.delegate = self
        setUI()
        bind()
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func setUI() {
        [logo, sceneView, bottomSheetview].forEach({self.view.addSubview($0)})
        [recognizeDescLabel, recognizeButton].forEach({self.bottomSheetview.addSubview($0)})
        
        logo.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(7)
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(32)
        })
        
        sceneView.snp.makeConstraints({
            $0.top.equalTo(self.logo.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        bottomSheetview.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(137)
        })
        
        recognizeDescLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        })
        
        recognizeButton.snp.makeConstraints({
            $0.top.equalTo(self.recognizeDescLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        })
    }
    
    private func bind() {
        recognizeButton.rx.tap
            .subscribe(onNext: {[weak self] in
//                self?.detectFood()
                self?.moveToRecognize()
            })
            .disposed(by: disposeBag)
    }
    
//    private func detectFood() {
//        
//        // 현재 AR 화면 캡처
//        let capturedImage = sceneView.snapshot()
//        
//        // 이미지를 서버로 전송
//        uploadImage(capturedImage) { [weak self] result in
//            switch result {
//            case .success(let detectedItems):
//                print("Upload successful. Detected items:")
//                detectedItems.forEach { print("- \($0)") }
//                // 여기에 성공 후 로직 추가 (예: 결과를 표시하거나 다음 화면으로 이동)
//                self?.moveToRecognize(detectedItems: detectedItems, catpturedImage: capturedImage)
//            case .failure(let error):
//                print("Upload failed: \(error.localizedDescription)")
//                // 에러 처리 (예: 사용자에게 알림)
//            }
//        }
//    }
    
//    private func moveToRecognize(detectedItems: [String], catpturedImage: UIImage) {
//        let recognizeVC = HomeRecognizeARViewController()
//        recognizeVC.modalPresentationStyle = .overFullScreen
//        recognizeVC.detectedFoodName = detectedItems
//        recognizeVC.capturedImage.image = catpturedImage
//        self.navigationController?.pushViewController(recognizeVC, animated: true)
//    }
    
    private func moveToRecognize() {
        let recognizeVC = VisionDetectViewController()
        recognizeVC.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.pushViewController(recognizeVC, animated: true)
    }
    
    
    private func uploadImage(_ image: UIImage, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let imageData = image.pngData() else {
            completion(.failure(NSError(domain: "ImageConversionError", code: 0, userInfo: nil)))
            return
        }
        
        LoadingIndicator.showLoading()
        
        let url = "" // 실제 API 엔드포인트로 변경해야 합니다
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "ar_capture.png", mimeType: "image/png")
        }, to: url, method: .post)
        .responseDecodable(of: DetectionResponse.self) { response in
            switch response.result {
            case .success(let detectionResponse):
                print("결과값 \(response.result)")
                let detectedItems = detectionResponse.rawResults.map { $0.name }
                LoadingIndicator.hideLoading()
                completion(.success(detectedItems))
            case .failure(let error):
                print("Upload error details: \(error)")
                LoadingIndicator.hideLoading()
                completion(.failure(error))
            }
        }
    }
}
