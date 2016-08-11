//
//  OTMMapViewController.swift
//  On The Map
//
//  Created by martin chibwe on 7/19/16.
//  Copyright © 2016 martin chibwe. All rights reserved.
//

import UIKit
import MapKit



class OTMMapViewController: UIViewController {
	
	
	
	let otmDataSource = OTMDataSource.sharedDataSource()
	

	
	@IBOutlet weak var mapView: MKMapView!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mapView.delegate = self
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(studentLocationsDidUpdate), name: "\(ParseClient.Objects.StudentLocation)\(ParseClient.Notifications.ObjectUpdated)", object: nil)
		otmDataSource.refreshStudentLocations()
	}
	
	
	
	func studentLocationsDidUpdate() {
		
		var annotations = [MKPointAnnotation]()
		
		for studentLocation in otmDataSource.studentLocations {
			let annotation = MKPointAnnotation()
			annotation.coordinate = studentLocation.location.coordinate
			annotation.title = studentLocation.student.fullName
			annotation.subtitle = studentLocation.student.mediaURL
			annotations.append(annotation)
		}
		
		dispatch_async(dispatch_get_main_queue()) {
			self.mapView.removeAnnotations(self.mapView.annotations)
			self.mapView.addAnnotations(annotations)
		}
	}
	
	
	
	private func displayAlert(message: String) {
		let alertView = UIAlertController(title: "", message: message, preferredStyle: .Alert)
		alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
		self.presentViewController(alertView, animated: true, completion: nil)
	}
}



extension OTMMapViewController: MKMapViewDelegate {
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		
		let reuseId = "OTMPin"
		
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
		
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.pinTintColor = UIColor.redColor()
			pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
		}
		else {
			pinView!.annotation = annotation
		}
		
		return pinView
	}
	
	func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == view.rightCalloutAccessoryView {
			if let mediaURL = NSURL(string: ((view.annotation?.subtitle)!)!) {
				if UIApplication.sharedApplication().canOpenURL(mediaURL) {
					UIApplication.sharedApplication().openURL(mediaURL)
				} else {
					displayAlert(AppConstants.Errors.CannotOpenURL)
				}
			}
		}
	}
}