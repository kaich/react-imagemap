//
//  CKMapPopView.swift
//  AMPopTip
//
//  Created by mk on 2017/12/2.
//

import UIKit

class CKMapPopView: UIView {
    var marker: CKMapMarker?
    let lblTitle = UILabel()
    let lblMessage = UILabel()

    init(marker: CKMapMarker) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 90))
        
        backgroundColor = UIColor.white
        
        lblTitle.frame = CGRect(x: 0, y: 0, width: 150, height: 20)
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.systemFont(ofSize: 14)
        lblTitle.text = marker.title
        addSubview(lblTitle)
        
        let line = UIView(frame: CGRect(x: 0, y: 20, width: 150, height: 1))
        line.backgroundColor = UIColor.hexrgb("#f0f0f0")
        addSubview(line)
        
        lblMessage.frame = CGRect(x: 0, y: 21, width: 150, height: 60)
        lblMessage.font = UIFont.systemFont(ofSize: 12)
        lblMessage.text = "\(marker.point.x):\(marker.point.y)"
        addSubview(lblMessage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
