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
  var onClickAnnotation: RCTBubblingEventBlock?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    imageMapView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageMapView)
    imageMapView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    imageMapView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    imageMapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    imageMapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    
    imageMapView.clickAnnotationBlock = { marker in
      if let onClickAnnotation = self.onClickAnnotation {
        if let marker = marker {
          onClickAnnotation([
            "marker" : self.convertMarkerToJsonData(marker)
          ])
        }
        else {
          onClickAnnotation([
            "marker" : []
            ])
        }
      }
    }
    
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
  
  public var mapName: String? {
    didSet {
      if let mapName = self.mapName {
        imageMapView.mapName = mapName
      }
    }
  }
  
  func addMarker(_ markerData: [String : Any]?, isNeedReload: Bool) {
    if let marker = converJsonDataToMarker(markerData) {
      imageMapView.markers.append(marker)
    }
    if isNeedReload {
      imageMapView.reloadData()
    }
  }
  
  func addMarker(_ markerData: [String : Any]?) {
    addMarker(markerData, isNeedReload: true)
  }
  
  private var _markers: [Any] = []
  var markers: [Any] {
    set {
      _markers = newValue
      imageMapView.markers = []
      for emMarker in _markers {
        addMarker(emMarker as? [String : Any],isNeedReload: false)
      }
      imageMapView.reloadData()
    }
    get {
      return _markers
    }
  }
  
  
  func mark(_ markerData: [String : Any]?) {
    DispatchQueue.global().async {
      if let marker = self.converJsonDataToMarker(markerData) {
        let _ = self.imageMapView.mark(marker)
      }
    }
  }
  
  func unmark(_ markerData: [String : Any]?) {
    if let marker = converJsonDataToMarker(markerData) {
      let _ = imageMapView.unmark(marker)
    }
  }
  
  func checkMarked(_ markerData: [String : Any]?) -> Bool {
    if let marker = converJsonDataToMarker(markerData) {
      return imageMapView.checkMarked(marker)
    }
    return false
  }
  
  
  private func converJsonDataToMarker(_ markerData: [String : Any]?) -> CKMapMarker? {
    if let markerData = markerData  {
      return CKMapMarker(JSON: markerData)
    }
    return nil
  }
  
  private func convertMarkerToJsonData(_ marker: CKMapMarker) -> [String : Any] {
    return marker.toJSON()
  }

}
