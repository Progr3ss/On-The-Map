//
//  StudeentLocationTableViewCell.swift
//  On The Map
//
//  Created by martin chibwe on 7/22/16.
//  Copyright © 2016 martin chibwe. All rights reserved.
//

import UIKit

// MARK: - StudentLocationTableViewCell: UITableViewCell

class StudentLocationTableViewCell: UITableViewCell {
	

	
	@IBOutlet weak var pinImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var urlLabel: UILabel!
	
	
	func configureWithStudentLocation(studentLocation: StudentLocation) {
		pinImageView.image = UIImage(named: "pin")
		nameLabel.text = studentLocation.student.fullName
		urlLabel.text = studentLocation.student.mediaURL
	}
}
