//
//  SportsModel.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import Foundation

class SportsModel: Codable {
    
    var sportID: String
    var sportName: String
    var SportThumbnail: String
    var SportType: String
    
    enum CodingKeys: String,CodingKey {
        case sportID = "idSport"
        case sportName = "strSport"
        case SportThumbnail = "strSportThumb"
        case SportType = "strFormat"
    }
    
}
