//
//  RecognizeFoodARViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/7/24.
//

import UIKit
import SceneKit
import ARKit
import RxSwift
import RxCocoa
import SnapKit

class RecognizeFoodARViewController: UIViewController, ARSCNViewDelegate {
    
    private let viewModel = RecipeGuideViewModel()
    private let disposeBag = DisposeBag()
    
    var sceneView: ARSCNView!
    var planeNode: SCNNode?
    
    private let ingredientsImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AR 뷰 설정
        sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
//        sceneView.autoenablesDefaultLighting = true
        view.addSubview(sceneView)
        
        // 제스처 인식기 추가
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
//        sceneView.addGestureRecognizer(pinchGesture)
//        sceneView.addGestureRecognizer(panGesture)
//        sceneView.addGestureRecognizer(tapGesture)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        // 모델 추가
//        addModel()
        
        showRecipeGuide()
        setUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func addModel() {
        guard let planeScene = SCNScene(named: "art.scnassets/ship.scn") else {
            print("Failed to load plane model")
            return
        }
        
        if let planeNode = planeScene.rootNode.childNodes.first {
            planeNode.position = SCNVector3(0, 0, -0.5) // 카메라 앞에 위치
            sceneView.scene.rootNode.addChildNode(planeNode)
            self.planeNode = planeNode
        }
    }
    
    private func setUI() {
        self.sceneView.addSubview(ingredientsImageView)
        
        ingredientsImageView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(150)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(350)
        })
    }
    
    private func showRecipeGuide() {
//        let viewModel = RecipeGuideViewModel()
        
        let recipeGuideVC = RecipeGuideViewController(viewModel: self.viewModel)
        recipeGuideVC.modalPresentationStyle = .fullScreen
        
//        viewModel.fetchRecipeGuide(recipeName: "토마토달걀")
        
        viewModel.fetchMockRecipe()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            self.present(recipeGuideVC, animated: true)
        }
    }
    
    private func bind() {
        viewModel.currentStepIndex
            .subscribe(onNext: {[weak self] index in
                self?.updateIngredientImage(index)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func updateIngredientImage(_ index: Int) {
        switch index {
        case 0:
            return
        case 1:
            return
        case 2:
            self.ingredientsImageView.image = UIImage(named: "AR_1")
            return
        case 3:
            self.ingredientsImageView.image = UIImage(named: "AR_2")
            return
        case 4:
            self.ingredientsImageView.image = UIImage(named: "AR_1")
            return
        case 5:
            self.ingredientsImageView.image = UIImage(named: "AR_4")
            return
        case 6:
            self.ingredientsImageView.image = UIImage(named: "AR_5")
            return
        case 7:
            self.ingredientsImageView.image = UIImage(named: "AR_6")
            return
        case 8:
            self.ingredientsImageView.image = UIImage(named: "AR_7")
            return
        case 9:
            self.ingredientsImageView.image = UIImage(named: "AR_8")
            return
        case 10:
            self.ingredientsImageView.image = UIImage(named: "AR_9")
        case 11:
            self.ingredientsImageView.image = UIImage(named: "tomato_food_AR")
            return
        default:
            return
        }
    }
    
    
//    @objc func pinch(_ gesture: UIPinchGestureRecognizer) {
//        guard let planeNode = planeNode else { return }
//        
//        if gesture.state == .changed {
//            let pinchScale = Float(gesture.scale)
//            planeNode.scale = SCNVector3(pinchScale * planeNode.scale.x,
//                                         pinchScale * planeNode.scale.y,
//                                         pinchScale * planeNode.scale.z)
//            gesture.scale = 1
//        }
//    }
//    
//    @objc func pan(_ gesture: UIPanGestureRecognizer) {
//        guard let planeNode = planeNode else { return }
//        
//        if gesture.state == .changed {
//            let translation = gesture.translation(in: sceneView)
//            let angleY = Float(translation.x) * (Float.pi / 180)
//            let angleX = Float(translation.y) * (Float.pi / 180)
//            
//            planeNode.eulerAngles.y += angleY
//            planeNode.eulerAngles.x += angleX
//            
//            gesture.setTranslation(.zero, in: sceneView)
//        }
//    }
//    
//    @objc func tap(_ gesture: UITapGestureRecognizer) {
//        guard let planeNode = planeNode else { return }
//        
//        
//        let action = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi / 4), z: 0, duration: 0.3)
//        planeNode.runAction(action)
//    }
}
