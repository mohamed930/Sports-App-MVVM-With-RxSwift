//
//  UpcommingCell.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import UIKit

class UpcommingCell: UICollectionViewCell {
    
    @IBOutlet weak var EventTumbnailImageView: UIImageView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var EventNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        MakeItCricle(image: EventTumbnailImageView)
//        self.contentView.layer.cornerRadius = 9
//        self.contentView.layer.masksToBounds = true
//        self.contentView.layer.borderWidth = 0
    }

    func MakeItCricle(image: UIImageView) {
        image.layer.cornerRadius = 9
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0

    }
    
    func configureCell (branch: EventsModel) {
        
        EventNameLabel.text = branch.strEvent
        DateLabel.text = branch.dateEvent
        
        DispatchQueue.main.async {
            
           if (branch.strThumb == "" || branch.strThumb == "No_image") {
                self.EventTumbnailImageView.image = UIImage(named: "No_image")
                self.EventNameLabel.textColor = UIColor.black
                self.DateLabel.textColor = UIColor.black
           }
           else {
                self.EventTumbnailImageView.kf.setImage(with:URL(string: branch.strThumb ?? ""))
           }
        }
        
    }
    
}
