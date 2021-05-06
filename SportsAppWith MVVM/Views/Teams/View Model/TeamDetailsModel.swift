//
//  TeamDetailsModel.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import Foundation
import RxCocoa
import RxSwift
import SafariServices

class TeamDetailsViewModel {
    
    var PickedTeamID = BehaviorRelay<String>(value: "")
    var PickedFacebook = BehaviorRelay<String>(value: "")
    var PickedTwitter = BehaviorRelay<String>(value: "")
    var PickedInstegram = BehaviorRelay<String>(value: "")
    
    private var TeamModelSubject = PublishSubject<[AllTemasModel]>()
    
    var TeamModelSubjectObserval:Observable<[AllTemasModel]> {
        return TeamModelSubject
    }
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    func GetLeagueData() {
        
        loadingBehavior.accept(true)
        
        let ob = TeamsAPI()
        
        ob.GetTeamDetials(TeamID: PickedTeamID.value) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let res):
                guard let res = res else { return }
                
                self.TeamModelSubject.onNext(res.teams)
                
                self.loadingBehavior.accept(false)
                
            case .failure(_):
                self.loadingBehavior.accept(false)
                print("Error")
            }
        }
        
    }
    
    private func openSafari(Url: String,ob:UIViewController) {
        let u = "HTTPS://\(Url)"
        let safariVC = SFSafariViewController(url: URL(string: u)!)
        ob.present(safariVC, animated: true)
    }
        
    private func createAlert (Title:String , Mess:String , ob:UIViewController) {
        
        let alert = UIAlertController(title: Title , message:Mess
            , preferredStyle:UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        ob.present(alert,animated:true,completion: nil)
    }
        
    func CheckLinkAndViewIt(url: String, delegate: UIViewController) {
       if url == "" || url == "nil" {
           createAlert(Title: "Attension", Mess: "There is no link to show to you", ob: delegate)
       }
       else {
           openSafari(Url: url, ob : delegate)
       }
   }
    
}
