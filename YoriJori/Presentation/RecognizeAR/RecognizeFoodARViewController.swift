//
//  RecognizeFoodARViewController.swift
//  YoriJori
//
//  Created by 김강현 on 8/7/24.
//

import UIKit
import SceneKit
import ARKit

class RecognizeFoodARViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!
    var planeNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AR 뷰 설정
        sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        view.addSubview(sceneView)
        
        // 제스처 인식기 추가
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        sceneView.addGestureRecognizer(pinchGesture)
        sceneView.addGestureRecognizer(panGesture)
        sceneView.addGestureRecognizer(tapGesture)
        
        // AR 세션 구성 (평면 감지 없음)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        // 모델 추가
        addModel()
        
        showRecipeGuide()
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
    
    private func showRecipeGuide() {
        let viewModel = RecipeGuideViewModel()
        
        let recipeGuideVC = RecipeGuideViewController(viewModel: viewModel)
        recipeGuideVC.modalPresentationStyle = .overFullScreen
        
        viewModel.fetchRecipeGuide(recipeName: "퀴노아닭가슴살샐러드")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            self.present(recipeGuideVC, animated: true, completion: nil)
        }
    }
    
    @objc func pinch(_ gesture: UIPinchGestureRecognizer) {
        guard let planeNode = planeNode else { return }
        
        if gesture.state == .changed {
            let pinchScale = Float(gesture.scale)
            planeNode.scale = SCNVector3(pinchScale * planeNode.scale.x,
                                         pinchScale * planeNode.scale.y,
                                         pinchScale * planeNode.scale.z)
            gesture.scale = 1
        }
    }
    
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        guard let planeNode = planeNode else { return }
        
        if gesture.state == .changed {
            let translation = gesture.translation(in: sceneView)
            let angleY = Float(translation.x) * (Float.pi / 180)
            let angleX = Float(translation.y) * (Float.pi / 180)
            
            planeNode.eulerAngles.y += angleY
            planeNode.eulerAngles.x += angleX
            
            gesture.setTranslation(.zero, in: sceneView)
        }
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        guard let planeNode = planeNode else { return }
        
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi / 4), z: 0, duration: 0.3)
        planeNode.runAction(action)
    }
}
