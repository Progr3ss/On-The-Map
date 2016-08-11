//
//  UdacityConstants.swift
//  On The Map
//
//  Created by martin chibwe on 7/22/16.
//  Copyright © 2016 martin chibwe. All rights reserved.
//

import Foundation
extension UdacityClient {
	

	
	struct Common {
		static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
	}
	
	
	
	struct Errors {
		static let Domain = "UdacityClient"
		static let UnableToLogin = "Unable to login."
		static let UnableToLogout = "Unable to logout."
		static let NoUserData = "Cannot access user data."
	}
	
	
	
	struct Components {
		static let Scheme = "https"
		static let Host = "www.udacity.com"
		static let Path = "/api"
	}
	

	
	struct Methods {
		static let Session = "/session"
		static let Users = "/users"
	}
	
	
	
	struct Cookies {
		static let XSRFToken = "XSRF-TOKEN"
	}
	
	
	
	struct HeaderKeys {
		static let Accept = "Accept"
		static let ContentType = "Content-Type"
		static let XSRFToken = "X-XSRF-TOKEN"
	}
	
	
	
	struct HeaderValues {
		static let JSON = "application/json"
	}
	
	
	
	struct HTTPBodyKeys {
		static let Udacity = "udacity"
		static let Username = "username"
		static let Password = "password"
	}
	
	
	
	struct JSONResponseKeys {
		static let Account = "account"
		static let UserKey = "key"
		static let Status = "status"
		static let Session = "session"
		static let Error = "error"
		static let User = "user"
		static let FirstName = "first_name"
		static let LastName = "last_name"
	}
}