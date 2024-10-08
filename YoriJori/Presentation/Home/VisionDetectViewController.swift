//
//  VisionDetectViewController.swift
//  YoriJori
//
//  Created by 김강현 on 10/6/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AVFoundation
import Vision

class VisionDetectViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let disposeBag = DisposeBag()
    
    public var test = ""
    
    private var capturedImage: UIImage?
    private var recognizedObjects: [(identifier: String, boundingBox: CGRect)] = []
    private var lastUpdateTime: Date = Date()
    private let updateInterval: TimeInterval = 0.5 // 0.5초마다 업데이트
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "chevron_left")?.withTintColor(DesignSystemColor.white), for: .normal)
    }
    
    private let bottomButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private let resultButton = YorijoriFilledButton(bgColor: DesignSystemColor.yorijoriPink, textColor: DesignSystemColor.white).then {
        $0.text = "결과 보기"
    }
    
    private let reRecognizeButton = YorijoriFilledButton(bgColor: DesignSystemColor.gray150, textColor: DesignSystemColor.gray700).then {
        $0.text = "재인식"
    }
    
    // MARK: - Vision Properties
    
    private var bufferSize: CGSize = .zero
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    private var detectionOverlay: CALayer! = nil
    private var requests = [VNRequest]()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupAVCapture()
        setupVision()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayerGeometry()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        startCaptureSession()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCaptureSession()
    }
    
    // MARK: - Setup Methods
    
    private func setupAVCapture() {
        var deviceInput: AVCaptureDeviceInput!
        
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480
        
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        do {
            try videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        setupLayers()
        updateLayerGeometry()
        setUI()
        bind()
    }
    
    private func setUI() {
        [backButton, bottomButtonStackView].forEach({self.view.addSubview($0)})
        [resultButton, reRecognizeButton].forEach({self.bottomButtonStackView.addArrangedSubview($0)})
        
        backButton.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(22)
        })
        
        bottomButtonStackView.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(50)
        })
        
        reRecognizeButton.snp.makeConstraints({
            $0.width.equalTo(77)
        })
    }
    
    private func bind() {
        resultButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.moveToIngredientInfo()
            })
            .disposed(by: disposeBag)
    }
    
    private func moveToIngredientInfo() {
        guard let capturedImage = capturedImage else {
                    print("No image captured")
                    return
                }
        
        let ingredientVC = IngredientInfoViewController()
        ingredientVC.modalPresentationStyle = .overFullScreen
        
        ingredientVC.captureImageView.image = capturedImage
        ingredientVC.recognizedObjects = self.recognizedObjects
        
        self.navigationController?.pushViewController(ingredientVC, animated: true)
    }
    
    private func rotateImage(_ image: UIImage, byDegrees degrees: CGFloat) -> UIImage {
        let radians = degrees * .pi / 180
        let rotatedSize = CGRect(origin: .zero, size: image.size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2,
                                  width: image.size.width, height: image.size.height))
        }
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage ?? image
    }

    
    private func setupVision() {
        guard let modelURL = Bundle.main.url(forResource: "light_best", withExtension: "mlmodelc") else {
            print("Model file is missing")
            return
        }
        
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async {
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                    }
                }
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
    }
    
    private func setupLayers() {
        detectionOverlay = CALayer()
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionOverlay.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.layer.addSublayer(detectionOverlay)
    }
    
    private func updateLayerGeometry() {
        let bounds = view.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
    }
    
    // MARK: - Vision Methods
    
    private func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil
        
//        recognizedObjects.removeAll()
        
        let currentTime = Date()
        if currentTime.timeIntervalSince(lastUpdateTime) >= updateInterval {
            // updateInterval 시간이 지났을 때만 recognizedObjects 업데이트
            var newRecognizedObjects: [(identifier: String, boundingBox: CGRect)] = []
            
            for observation in results where observation is VNRecognizedObjectObservation {
                guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
                let topLabelObservation = objectObservation.labels[0]
                let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
                
                newRecognizedObjects.append((identifier: topLabelObservation.identifier, boundingBox: objectBounds))
                
                let shapeLayer = createRoundedRectLayerWithBounds(objectBounds)
                let textLayer = createTextSubLayerInBounds(objectBounds, identifier: topLabelObservation.identifier)
                shapeLayer.addSublayer(textLayer)
                detectionOverlay.addSublayer(shapeLayer)
            }
            
            if !newRecognizedObjects.isEmpty {
                recognizedObjects = newRecognizedObjects
                lastUpdateTime = currentTime
            }
        } else {
            // updateInterval 내에는 기존 recognizedObjects를 사용하여 화면 업데이트
            for object in recognizedObjects {
                let shapeLayer = createRoundedRectLayerWithBounds(object.boundingBox)
                let textLayer = createTextSubLayerInBounds(object.boundingBox, identifier: object.identifier)
                shapeLayer.addSublayer(textLayer)
                detectionOverlay.addSublayer(shapeLayer)
            }
        }
        
        updateLayerGeometry()
        CATransaction.commit()
        
        // 콘솔에 인식된 객체 정보 출력
        printRecognizedObjects()
    }
    
    private func printRecognizedObjects() {
           print("Recognized Objects:")
           for (index, object) in recognizedObjects.enumerated() {
               print("Object \(index + 1):")
               print("  Identifier: \(object.identifier)")
               print("  Bounding Box: x: \(object.boundingBox.origin.x), y: \(object.boundingBox.origin.y), width: \(object.boundingBox.width), height: \(object.boundingBox.height)")
           }
           print("------------------------")
       }
    
    private func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        
        // 텍스트 설정
        let attributedString = NSAttributedString(
            string: identifier,
            attributes: [
                .font: DesignSystemFont.bold16,
                .foregroundColor: UIColor.black
            ]
        )
        
        textLayer.string = attributedString
        
        // 텍스트 레이어 크기 설정
        let textSize = attributedString.size()
        textLayer.bounds = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        // 텍스트 레이어를 바운딩 박스의 중앙에 위치시킴
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // 텍스트 스타일 설정
        textLayer.alignmentMode = .center
        textLayer.isWrapped = true
        textLayer.contentsScale = UIScreen.main.scale
        
        // 텍스트 변환 설정 (카메라 입력에 맞춰 조정)
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        
        return textLayer
    }
    
    private func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        
        // 바운딩 박스 스타일 설정
        shapeLayer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
        shapeLayer.cornerRadius = 12
        
        return shapeLayer
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        capturedImage = rotateImage(uiImage, byDegrees: 90)
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Utilities
    
    private func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:
            exifOrientation = .down
        case UIDeviceOrientation.portrait:
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
    
    private func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    private func stopCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }
}
