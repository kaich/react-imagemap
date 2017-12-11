//
//  CKImageMapView.swift
//  ImageMapView
//
//  Created by mk on 2017/12/1.
//

import UIKit
import AMPopTip
import Kingfisher

public class CKImageMapView: UIView {
    //Map Image View
    public var imageURL: URL? {
        didSet {
            ivMap.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
                self.mapImage = image
                self.ivMap.frame = CGRect(x: 0, y: 0, width: self.mapSize().width, height: self.mapSize().height)
                self.scrollView.contentSize = self.mapSize()
                self.setNeedsLayout()
            }
            
        }
    }
    //All Map Annotation Markers
    public var markers: [CKMapMarker] = [] {
        didSet {
            self.reloadData()
        }
    }
    //Show Default Popup View
    public var showDefaultPopView = true
    //When User Click AnnotationView Call This
    public var clickAnnotationBlock :((CKMapMarker?) -> ())?

    private let scrollView = UIScrollView()
    private let ivMap = UIImageView()
    private var mapImage: UIImage?
    private var isInitialScaled = false //处理开始frame大小为0的情况
    private let popTip = PopTip()
    private var annotationViews = [CKMapAnotationView]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        scrollView.delegate = self
        addSubview(scrollView)


        ivMap.isUserInteractionEnabled = true
        scrollView.addSubview(ivMap)
        
        popTip.bubbleColor = UIColor.white
        popTip.shouldDismissOnTap = true
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(userDoubleTappedScrollview(recognizer:)))
        tapGes.numberOfTapsRequired = 2
        ivMap.addGestureRecognizer(tapGes)

    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        initialZoomScale()
        
    }
    
    public func reloadData() {
        layoutAnnotations()
    }
    
    func initialZoomScale() {
        if !isInitialScaled {
            if let mapImage = self.mapImage {
                let mapSize = mapImage.size
                let screenSize = UIScreen.main.bounds.size
                let widthScale =  screenSize.width / mapSize.width
                let heightScale =  screenSize.height / mapSize.height
                
                let minScale = widthScale < heightScale ? widthScale : heightScale
                scrollView.minimumZoomScale = minScale
                scrollView.maximumZoomScale = 1
                scrollView.setZoomScale(minScale, animated: false)

                isInitialScaled = true
            }
        }
    }
    
    func mapSize() -> CGSize {
        if let mapImage = self.mapImage {
            return mapImage.size
        }
        return CGSize(width: 0, height: 0)
    }
    
    func layoutAnnotations() {
        annotationViews = []
        for emView in scrollView.subviews {
            if let emView = emView as? CKMapAnotationView {
                emView.removeFromSuperview()
            }
        }
        for marker in markers {
            let annotationView = CKMapAnotationView(marker: marker)
            annotationView.clickBlock = { annotationView in
                if self.showDefaultPopView {
                    self.showPopView(annotationView: annotationView)
                }
                if let clickAnnotationBlock = self.clickAnnotationBlock {
                    clickAnnotationBlock(annotationView.marker)
                }
            }
            let finalPoint = ivMap.convert(marker.point, to: scrollView)
            annotationView.finalCenterPoint = finalPoint
            scrollView.addSubview(annotationView)
            annotationViews.append(annotationView)
            
        }
    }
    
    func showPopView(annotationView: CKMapAnotationView) {
        let infoView = CKMapPopView(marker: annotationView.marker!)
        popTip.show(customView: infoView, direction: .up, in: scrollView, from: annotationView.frame)
    }
    
    @objc func userDoubleTappedScrollview(recognizer:  UITapGestureRecognizer) {
        let scrollV = scrollView
        if (scrollV.zoomScale > scrollV.minimumZoomScale) {
            scrollV.setZoomScale(scrollV.minimumZoomScale, animated: true)
        }
        else {
            //(I divide by 3.0 since I don't wan't to zoom to the max upon the double tap)
            let zoomRect = self.zoomRectForScale(scale: scrollV.maximumZoomScale / 3.0, center: recognizer.location(in: recognizer.view))
            self.scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    func zoomRectForScale(scale : CGFloat, center : CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let imageV = ivMap
        zoomRect.size.height = imageV.frame.size.height / scale;
        zoomRect.size.width  = imageV.frame.size.width  / scale;
        let newCenter = imageV.convert(center, from: self.scrollView)
        zoomRect.origin.x = newCenter.x - ((zoomRect.size.width / 2.0));
        zoomRect.origin.y = newCenter.y - ((zoomRect.size.height / 2.0));
        
        return zoomRect;
    
    }
    
    func rectToImageWith(scale: CGFloat, from: CGRect) -> CGRect {
        let finalFrame = CGRect(x: from.origin.x * scale, y: from.origin.y * scale, width: from.width, height: from.height)
        return finalFrame
    }

    
}


extension CKImageMapView :  UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ivMap
    }

    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let subView = scrollView.subviews.first
        
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) / 2, 0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) / 2, 0)
        subView?.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        
        for annoView in annotationViews {
            let finalPoint = ivMap.convert((annoView.marker?.point)!, to: scrollView)
            if(popTip.from == annoView.frame) {
                annoView.finalCenterPoint = finalPoint
                popTip.from = annoView.frame
            }
            else {
                annoView.finalCenterPoint = finalPoint
            }
        }
    }
    
}
