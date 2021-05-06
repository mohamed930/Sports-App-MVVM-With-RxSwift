//
//  AllTeamsViewModel.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation
import RxCocoa
import RxSwift

struct AllTeamsViewModel {
    
    var PickedLeagueTitleName = BehaviorRelay<String>(value: "")
    
    private var TeamsModelSubject = PublishSubject<[AllTemasModel]>()
    
    var TeamsModelSubjectObserval:Observable<[AllTemasModel]> {
        return TeamsModelSubject
    }
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    func GetLeagueData() {
        
        loadingBehavior.accept(true)
        
        let ob = TeamsAPI()
        
        ob.GetAllTeams(LeagueName: PickedLeagueTitleName.value) { response in
            
            switch response {
            
            case .success(let res):
                guard let res = res else { return }
                
                self.TeamsModelSubject.onNext(res.teams)
                
                self.loadingBehavior.accept(false)
                
            case .failure(_):
                self.loadingBehavior.accept(false)
                print("Error")
            }
        }
    }
    
}
