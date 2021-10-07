//
//  ViewController.swift
//  CropExample
//
//  Created by AP Yauheni Hramiashkevich on 9/30/21.
//

import UIKit
import SnapKit

class ViewController: UIViewController, RKUserResizableViewDelegate {
    func userResizableViewDidBeginEditing(_ userResizableView: RKUserResizableView) {
        
    }
    
    func userResizableViewDidEndEditing(_ userResizableView: RKUserResizableView) {
        
    }
    
    
    let initialImageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 300, height: 300))
    let snapshotView = UIImageView()
    var imageResizableView = RKUserResizableView()
    var snapshot: UIImage?
    let snapshotButton = UIButton()
    let finalImage = UIImageView(frame: CGRect(x: 0, y: 500, width: 300, height: 300))

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialImage()
        setCroppedImage()
        
        view.addSubview(finalImage)
        finalImage.contentMode = .center
        finalImage.clipsToBounds = true
        setSnapshotButton()
     //   addResizeButton()
        //createMask()

        
    }
}

private extension ViewController {
    
    func setInitialImage()  {
        view.addSubview(initialImageView)
        initialImageView.clipsToBounds = true
        initialImageView.image = UIImage(named: "testImg")
    
    }
    
    
    func setBluredSnapshotView()  {
        snapshot = view.snapshot()
        view.addSubview(snapshotView)
        
        initialImageView.isHidden = true
        snapshotView.image = snapshot?.alpha(0.1)
        
        snapshotView.snp.makeConstraints { make in
            make.top.equalTo(initialImageView.snp.top)
            make.leading.equalTo(initialImageView.snp.leading)
            make.trailing.equalTo(initialImageView.snp.trailing)
            make.bottom.equalTo(initialImageView.snp.bottom)
        }
    }
    
    func  setCroppedImage() {
        let imageFrame = initialImageView.frame
        imageResizableView = RKUserResizableView(frame: imageFrame, originalImageFrame: imageFrame)
        let imageView = UIImageView()
        imageView.contentMode = .init(rawValue: 0)!
        imageView.clipsToBounds = true
        imageResizableView.contentView = imageView
        imageResizableView.delegate = self
        self.view.addSubview(imageResizableView)
        
    }
    
    func createMask()  {
        let sampleMask = UIView()
            sampleMask.frame = self.view.frame
            sampleMask.backgroundColor =  UIColor.black.withAlphaComponent(0.6)
            //assume you work in UIViewcontroller
            self.view.addSubview(sampleMask)
            let maskLayer = CALayer()
            maskLayer.frame = sampleMask.bounds
            let circleLayer = CAShapeLayer()
            //assume the circle's radius is 150
            circleLayer.frame = CGRect(x:0 , y:0,width: sampleMask.frame.size.width,height: sampleMask.frame.size.height)
            let finalPath = UIBezierPath(roundedRect: CGRect(x:0 , y:0,width: sampleMask.frame.size.width,height: sampleMask.frame.size.height), cornerRadius: 0)
        let circlePath = UIBezierPath(rect: CGRect(x: sampleMask.center.x - 50, y: sampleMask.center.y - 50, width: 100, height: 100))
            finalPath.append(circlePath.reversing())
            circleLayer.path = finalPath.cgPath
            circleLayer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
             circleLayer.borderWidth = 1
            maskLayer.addSublayer(circleLayer)

            sampleMask.layer.mask = maskLayer
    }
    
    
    func setSnapshotButton()  {
        self.view.addSubview(snapshotButton)
        snapshotButton.setTitle("Snapshot", for: .normal)
        snapshotButton.backgroundColor = .green
        snapshotButton.addTarget(self, action: #selector(makeSnapshot), for: .touchUpInside)
        
        snapshotButton.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    @objc func makeSnapshot(_ sender: UIButton) {
        print(imageResizableView.frame.width)
        print(initialImageView.frame.height)
        print(imageResizableView.frame.minX)
        print(imageResizableView.frame.minY)
        
        let initialX = imageResizableView.frame.minX - initialImageView.frame.minX
        let initialY = imageResizableView.frame.minY - initialImageView.frame.minY

        let image = initialImageView.snapshot(of: CGRect(x: initialX, y: initialY, width: imageResizableView.frame.width, height: imageResizableView.frame.height), afterScreenUpdates: false)
        finalImage.frame.size = imageResizableView.frame.size
        finalImage.image = image
    }
}


extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return img
    }
}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


extension UIView {


    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
}
