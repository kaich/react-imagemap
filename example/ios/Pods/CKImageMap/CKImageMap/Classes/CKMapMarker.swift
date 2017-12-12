//
//  CKMapMarker.swift
//  ImageMapView
//
//  Created by mk on 2017/12/2.
//

import UIKit
import Kingfisher
import ObjectMapper


class PointTransform: TransformType {
    public typealias Object = CGPoint
    public typealias JSON = [String : CGFloat]
    
    public init() {}
    
    func transformFromJSON(_ value: Any?) -> CGPoint? {
        if let value  = value as? [String : CGFloat] {
            if let x = value["x"], let y = value["y"] {
                return CGPoint(x: x, y: y)
            }
        }
        return CGPoint.zero
    }
    
    func transformToJSON(_ value: CGPoint?) -> [String : CGFloat]? {
        if let value = value {
            return [
                "x" : value.x,
                "y" : value.y,
            ]
        }
        return nil
    }
    
}


class SizeTransform: TransformType {
    public typealias Object = CGSize
    public typealias JSON = [String : CGFloat]
    
    public init() {}
    
    func transformFromJSON(_ value: Any?) -> CGSize? {
        if let value  = value as? [String : CGFloat] {
            if let width = value["width"], let height = value["height"] {
                return CGSize(width: width, height: height)
            }
        }
        return CGSize.zero
    }
    
    func transformToJSON(_ value: CGSize?) -> [String : CGFloat]? {
        if let value = value {
            return [
                "width" : value.width,
                "height" : value.height
            ]
        }
        return nil
    }
    
}


class URLTransform: TransformType {
    public typealias Object = URL
    public typealias JSON = String
    
    public init() {}
    
    func transformFromJSON(_ value: Any?) -> URL? {
        if let str = value as? String {
            return URL(string: str)
        }
        return nil
    }
    
    func transformToJSON(_ value: URL?) -> String? {
        return value?.absoluteString
    }
    
}

public class CKMapMarker: Mappable {
    public var point: CGPoint = CGPoint(x: 0, y: 0)
    public var size: CGSize = CGSize(width: 30, height: 40)
    public var imageURL: URL?
    public var markedImageURL: URL?
    public var title = ""
    public var message = ""
    public var actionTitles = [String]()
    
    public init(point: CGPoint, size: CGSize = CGSize(width: 30, height: 40), imageURL: URL? = nil,markedImageURL: URL? = nil, title: String = "", message: String = "", actionTitles: [String] = []) {
        self.point = point
        self.size = size
        self.imageURL = imageURL
        self.markedImageURL = markedImageURL
        self.title = title
        self.message = message
        self.actionTitles = actionTitles
    }
    
    public required init?(map: Map) {

    }
    
    // Mappable
    public func mapping(map: Map) {
        
        point    <- ( map["point"], PointTransform() )
        size         <- ( map["size"], SizeTransform() )
        imageURL      <- ( map["imageURL"], URLTransform() )
        title       <- map["arr"]
        message  <- map["message"]
        actionTitles     <- map["actionTitles"]
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
    
    func setupWith(isMarked: Bool) {
        var finalImageURL = self.marker?.imageURL
        if isMarked {
            finalImageURL = self.marker?.markedImageURL
        }
        if let imageURL = finalImageURL {
            btnAnnotation.kf.setImage(with: imageURL, for: .normal)
        }
        else {
            btnAnnotation.setImage(UIImage(named: ""), for: .normal)
        }
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
