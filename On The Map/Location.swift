//
//  Location.swift
//  On The Map
//
//  Created by martin chibwe on 7/22/16.
//  Copyright © 2016 martin chibwe. All rights reserved.
//

import Foundation

import MapKit

// MARK: - Location

struct Location {
	
	
	let latitude: Double
	let longitude: Double
	let mapString: String
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2DMake(latitude, longitude)
	}
}