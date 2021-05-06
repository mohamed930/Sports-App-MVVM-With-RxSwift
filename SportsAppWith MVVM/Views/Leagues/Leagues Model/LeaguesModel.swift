//
//  LeaguesModel.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import Foundation

class LeaguesModel: Codable {
    
    var id: String
    var LeagueTitle: String
    var SportType: String
    
    enum CodingKeys: String,CodingKey {
        case id = "idLeague"
        case LeagueTitle = "strLeague"
        case SportType = "strSport"
    }
    
}
