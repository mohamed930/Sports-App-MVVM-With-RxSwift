//
//  TeamsCell.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import UIKit

class TeamsCell: UICollectionViewCell {
    
    @IBOutlet weak var TeamLogoImageView: UIImageView!
    @IBOutlet weak var TeamNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func confingureCell (branch: AllTemasModel) {
        
        self.TeamNameLabel.text = branch.strTeam
                    
        if branch.strTeamBadge == "" || branch.strTeamBadge == "NoImage" {
            self.TeamLogoImageView.image = UIImage(named: "No_image")
        }
        else {
            DispatchQueue.main.async {
                self.TeamLogoImageView.kf.setImage(with:URL(string: branch.strTeamBadge ?? "No_image"))
            }
        }
    }

}
