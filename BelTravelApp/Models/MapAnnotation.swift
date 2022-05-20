//
//  MapAnnotation.swift
//  BelTravelApp
//
//  Created by Tatsiana Marchanka on 20.05.22.
//

import MapKit
import SwiftUI

class MapPinAnnotation: NSObject, MKAnnotation {
  @objc dynamic var coordinate: CLLocationCoordinate2D
  let title: String?
  let location: Location

  init(title: String,
	   location: Location,
	   coordinate: CLLocationCoordinate2D) {
	self.coordinate = coordinate
	self.title = title
	self.location = location
	super.init()
  }
}
