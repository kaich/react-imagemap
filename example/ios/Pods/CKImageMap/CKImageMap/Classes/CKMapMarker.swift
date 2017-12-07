//
//  CKMapMarker.swift
//  ImageMapView
//
//  Created by mk on 2017/12/2.
//

import UIKit
import Kingfisher

public class CKMapMarker: NSObject {
    public var point: CGPoint = CGPoint(x: 0, y: 0)
    public var size: CGSize = CGSize(width: 30, height: 40)
    public var imageURL: URL?
    public var title = ""
    public var message = ""
    public var isMarked = false
    public var actionTitles = [String]()
    
    public init(point: CGPoint, size: CGSize = CGSize(width: 30, height: 40), imageURL: URL? = nil, title: String = "", message: String = "", isMarked: Bool = false, actionTitles: [String] = []) {
        self.point = point
        self.size = size
        self.imageURL = imageURL
        self.title = title
        self.message = message
        self.isMarked = isMarked
        self.actionTitles = actionTitles
    }
}


class CKMapAnotationView: UIView {
    var clickBlock: ((CKMapAnotationView) -> ())?
    var marker: CKMapMarker?
    var finalCenterPoint: CGPoint? {
        didSet {
            if let finaCenter = self.finalCenterPoint {
                self.center = CGPoint(x: finaCenter.x, y: finaCenter.y - self.frame.height / 2.0)
            }
        }
    }
    
    private let btnAnnotation = UIButton(type: UIButtonType.custom)
    
    init(marker: CKMapMarker) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: marker.size))
        self.marker = marker
        
        let image = UIImage()
        btnAnnotation.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        btnAnnotation.setImage(image, for: .normal)
        btnAnnotation.backgroundColor = UIColor.clear
        if let imageURL = marker.imageURL {
            btnAnnotation.kf.setImage(with: imageURL, for: .normal)
        }
        else {
            btnAnnotation.setImage(UIImage(named: ""), for: .normal)
        }
        btnAnnotation.addTarget(self, action: #selector(pressAnnotation), for: .touchUpInside)
        addSubview(btnAnnotation)
        
        
        self.center = marker.point
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pressAnnotation() {
        if let clickBlock = clickBlock {
            clickBlock(self)
        }
    }
}
