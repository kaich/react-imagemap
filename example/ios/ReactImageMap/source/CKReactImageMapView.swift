//
//  CKReactImageMapView.swift
//  ReactImageMap
//
//  Created by mk on 2017/12/6.
//  Copyright © 2017年 Facebook. All rights reserved.
//

import UIKit
import CKImageMap

class CKReactImageMapView: UIView {
  let imageMapView = CKImageMapView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    imageMapView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageMapView)
    imageMapView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    imageMapView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    imageMapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    imageMapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public var imageURLString: String? {
    didSet {
      if let imageURLString = self.imageURLString {
        imageMapView.imageURL = URL(string: imageURLString)
      }
    }
  }
  
  
  func addMarker(_ markerData: [String : Any]?) {
    if let markerData = markerData {
      let marker = CKMapMarker(point: CGPoint.zero)
      for (key,value) in markerData {
        switch(key) {
        case "point":
          if let pointData = value as? [String : CGFloat] {
            if let x = pointData["x"], let y = pointData["y"] {
              marker.point = CGPoint(x: x, y: y)
            }
          }
          break
        case "size":
          if let sizeData = value as? [String : CGFloat] {
            if let width = sizeData["width"], let height = sizeData["height"] {
              marker.size = CGSize(width: width, height: height)
            }
          }
          break
        case  "imageURL":
          if let urlString = value as? String {
            marker.imageURL = URL(string: urlString)
          }
          break
        case  "title":
          if let str = value as? String {
            marker.title = str
          }
          break
        case  "message":
          if let str = value as? String {
            marker.message = str
          }
          break
        case  "isMarked":
          if let isMarked = value as? Bool {
            marker.isMarked = isMarked
          }
          break
        case  "actionTitles":
          if let strArray = value as? [String] {
            marker.actionTitles = strArray
          }
          break
        default:
          break
        }
        
      }
      imageMapView.markers.append(marker)
    }
  }
  
  private var _markers: [Any] = []
  var markers: [Any] {
    set {
      _markers = newValue
      for emMarker in _markers {
        addMarker(emMarker as? [String : Any])
      }
    }
    get {
      return _markers
    }
  }

}
