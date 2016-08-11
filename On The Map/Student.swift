//
//  Student.swift
//  On The Map
//
//  Created by martin chibwe on 7/22/16.
//  Copyright © 2016 martin chibwe. All rights reserved.
//

import Foundation

struct Student {

	
	let uniqueKey: String
	let firstName: String
	let lastName: String
	var mediaURL: String
	var fullName: String {
		return "\(firstName) \(lastName)"
	}
	

	
	init(uniqueKey: String) {
		self.uniqueKey = uniqueKey
		firstName = ""
		lastName = ""
		mediaURL = ""
	}
	
	init(uniqueKey: String, firstName: String, lastName: String, mediaURL: String) {
		self.uniqueKey = uniqueKey
		self.firstName = firstName
		self.lastName = lastName
		self.mediaURL = mediaURL
	}
}

