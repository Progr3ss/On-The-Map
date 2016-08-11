//
//  OTMTableViewController.swift
//  On The Map
//
//  Created by martin chibwe on 7/19/16.
//  Copyright © 2016 martin chibwe. All rights reserved.
//

import UIKit


class OTMTableViewController: UITableViewController {
	
	
	
	let otmDataSource = OTMDataSource.sharedDataSource()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = otmDataSource
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(studentLocationsDidUpdate), name: "\(ParseClient.Objects.StudentLocation)\(ParseClient.Notifications.ObjectUpdatedError)", object: nil)
	}
	
	
	func studentLocationsDidUpdate() {
		tableView.reloadData()
	}
	
	
	
	private func displayAlert(message: String) {
		let alertView = UIAlertController(title: "", message: message, preferredStyle: .Alert)
		alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
		self.presentViewController(alertView, animated: true, completion: nil)
	}
	

	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		let studentMediaURL = otmDataSource.studentLocations[indexPath.row].student.mediaURL
		
		if let mediaURL = NSURL(string: studentMediaURL) {
			if UIApplication.sharedApplication().canOpenURL(mediaURL) {
				UIApplication.sharedApplication().openURL(mediaURL)
			} else {
				displayAlert(AppConstants.Errors.CannotOpenURL)
			}
		}
	}
}