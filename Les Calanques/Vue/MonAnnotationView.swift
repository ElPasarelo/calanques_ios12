//
//  MonAnnotationView.swift
//  Les Calanques
//
//  Created by Matthieu PASSEREL on 26/07/2018.
//  Copyright © 2018 Matthieu PASSEREL. All rights reserved.
//

import UIKit
import MapKit

class MonAnnotationView: MKAnnotationView {
        
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        image = UIImage(named: "placeholder")
        canShowCallout = true
        detailCalloutAccessoryView = ajoutImage()
        rightCalloutAccessoryView = ajoutRightButton()
    }
    
    func ajoutImage() -> UIView? {
        guard let anno = annotation as? MonAnnotation else { return nil}
        let vue = UIView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
        let imageV = UIImageView(frame: vue.bounds)
        imageV.image = anno.calanque.image
        imageV.clipsToBounds = true
        imageV.contentMode = .scaleAspectFill
        vue.addSubview(imageV)
        return vue
    }
    
    func ajoutRightButton() -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: "detail"), for: .normal)
        btn.addTarget(self, action: #selector(ControllerAvecCarte.detail), for: .touchUpInside)
        return btn
    }

}
