//
//  ParseClient.swift
//  On The Map
//
//  Created by martin chibwe on 7/22/16.
//  Copyright © 2016 martin chibwe. All rights reserved.
//

import Foundation


class ParseClient {
	

	
	let apiSession: APISession
	
	
	init() {
		let apiData = APIData(scheme: Components.Scheme, host: Components.Host, path: Components.Path, domain: Errors.Domain)
		apiSession = APISession(apiData: apiData)
	}
	
	private static var sharedInstance = ParseClient()
	
	class func sharedClient() -> ParseClient {
		return sharedInstance
	}
	
	
	private func makeRequestForParse(url url: NSURL, method: HTTPMethod, body: [String:AnyObject]? = nil, responseHandler: (jsonAsDictionary: [String:AnyObject]?, error: NSError?) -> Void) {
		
		let headers = [
			HeaderKeys.AppId: HeaderValues.AppId,
			HeaderKeys.APIKey: HeaderValues.APIKey,
			HeaderKeys.Accept: HeaderValues.JSON,
			HeaderKeys.ContentType: HeaderValues.JSON
		]
		
		apiSession.makeRequestAtURL(url, method: method, headers: headers, body: body) { (data, error) in
			if let data = data {
				let jsonAsDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String:AnyObject]
				responseHandler(jsonAsDictionary: jsonAsDictionary, error: nil)
			} else {
				responseHandler(jsonAsDictionary: nil, error: error)
			}
		}
	}
	
	
	
	func studentLocationWithUserKey(userKey: String, completionHandler: (location: StudentLocation?, error: NSError?) -> Void) {
		
		let studentLocationURL = apiSession.urlForMethod(Objects.StudentLocation, parameters: [
			ParameterKeys.Where: "{\"\(ParameterKeys.UniqueKey)\":\"" + "\(userKey)" + "\"}"
			])
		
		makeRequestForParse(url: studentLocationURL, method: .GET) { (jsonAsDictionary, error) in
			
			guard error == nil else {
				completionHandler(location: nil, error: error)
				return
			}
			
			if let jsonAsDictionary = jsonAsDictionary,
				let studentDictionaries = jsonAsDictionary[JSONResponseKeys.Results] as? [[String:AnyObject]] {
				if studentDictionaries.count == 1 {
					completionHandler(location: StudentLocation(dictionary: studentDictionaries[0]), error: nil)
					return
				}
			}
			
			completionHandler(location: nil, error: self.apiSession.errorWithStatus(0, description: Errors.NoRecordAtKey))
		}
	}
	
	
	
	func studentLocations(completionHandler: (locations: [StudentLocation]?, error: NSError?) -> Void) {
		
		let studentLocationURL = apiSession.urlForMethod(Objects.StudentLocation, parameters: [
			ParameterKeys.Limit: ParameterValues.OneHundred,
			ParameterKeys.Order: ParameterValues.MostRecentlyUpdated
			])
		
		makeRequestForParse(url: studentLocationURL, method: .GET) { (jsonAsDictionary, error) in
			
			guard error == nil else {
				completionHandler(locations: nil, error: error)
				return
			}
			
			if let jsonAsDictionary = jsonAsDictionary,
				let studentDictionaries = jsonAsDictionary[JSONResponseKeys.Results] as? [[String:AnyObject]] {
				completionHandler(locations: StudentLocation.locationsFromDictionaries(studentDictionaries), error: nil)
				return
			}
			
			completionHandler(locations: nil, error: self.apiSession.errorWithStatus(0, description: Errors.NoRecords))
		}
	}
	
	
	
	func postStudentLocation(mediaURL: String, studentLocation: StudentLocation, completionHandler: (success: Bool, error: NSError?) -> Void) {
		
		let studentLocationURL = apiSession.urlForMethod(Objects.StudentLocation)
		let studentLocationBody: [String:AnyObject] = [
			BodyKeys.UniqueKey: studentLocation.student.uniqueKey,
			BodyKeys.FirstName: studentLocation.student.firstName,
			BodyKeys.LastName: studentLocation.student.lastName,
			BodyKeys.MapString: studentLocation.location.mapString,
			BodyKeys.MediaURL: mediaURL,
			BodyKeys.Latitude: studentLocation.location.latitude,
			BodyKeys.Longitude: studentLocation.location.longitude
		]
		
		makeRequestForParse(url: studentLocationURL, method: .POST, body: studentLocationBody) { (jsonAsDictionary, error) in
			
			guard error == nil else {
				completionHandler(success: false, error: error)
				return
			}
			
			// success
			if let jsonAsDictionary = jsonAsDictionary,
				let _ = jsonAsDictionary[JSONResponseKeys.ObjectID] as? String {
				completionHandler(success: true, error: nil)
				return
			}
			
			// known failure
			if let jsonAsDictionary = jsonAsDictionary,
				let error = jsonAsDictionary[JSONResponseKeys.Error] as? String {
				completionHandler(success: true, error: self.apiSession.errorWithStatus(0, description: error))
				return
			}
			
			// unknown failure
			completionHandler(success: false, error: self.apiSession.errorWithStatus(0, description: Errors.CouldNotPostLocation))
		}
	}
	

	
	func updateStudentLocationWithObjectID(objectID: String, mediaURL: String, studentLocation: StudentLocation, completionHandler: (success: Bool, error: NSError?) -> Void) {
		
		let studentLocationURL = apiSession.urlForMethod(Objects.StudentLocation, withPathExtension: "/\(objectID)")
		let studentLocationBody: [String:AnyObject] = [
			BodyKeys.UniqueKey: studentLocation.student.uniqueKey,
			BodyKeys.FirstName: studentLocation.student.firstName,
			BodyKeys.LastName: studentLocation.student.lastName,
			BodyKeys.MapString: studentLocation.location.mapString,
			BodyKeys.MediaURL: mediaURL,
			BodyKeys.Latitude: studentLocation.location.latitude,
			BodyKeys.Longitude: studentLocation.location.longitude
		]
		
		makeRequestForParse(url: studentLocationURL, method: .PUT, body: studentLocationBody) { (jsonAsDictionary, error) in
			
			guard error == nil else {
				completionHandler(success: false, error: error)
				return
			}
			
			// success
			if let jsonAsDictionary = jsonAsDictionary,
				let _ = jsonAsDictionary[JSONResponseKeys.UpdatedAt] {
				completionHandler(success: true, error: nil)
				return
			}
			
			// known failure
			if let jsonAsDictionary = jsonAsDictionary,
				let error = jsonAsDictionary[JSONResponseKeys.Error] as? String {
				completionHandler(success: true, error: self.apiSession.errorWithStatus(0, description: error))
				return
			}
			
			// unknown failure
			completionHandler(success: false, error: self.apiSession.errorWithStatus(0, description: Errors.CouldNotUpdateLocation))
		}
	}
}
