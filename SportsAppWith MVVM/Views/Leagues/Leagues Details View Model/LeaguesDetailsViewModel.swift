//
//  LeaguesDetailsViewModel.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import Foundation
import RxCocoa
import RxSwift

class LeaguesDetailsViewModel {
    
    var PickedLeagueID = BehaviorRelay<String>(value: "")
    
    private var LeaguesDetailsModelSubject = PublishSubject<[LeaguesDetailsModel]>()
    
    var LeaguesDetailsModelSubjectObserval:Observable<[LeaguesDetailsModel]> {
        return LeaguesDetailsModelSubject
    }
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    func GetLeagueData() {
        
        loadingBehavior.accept(true)
        
        let ob = LeaguesAPI()
        
        ob.GetLeagueDetails(id: PickedLeagueID.value) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let res):
                guard let res = res else { return }
                
                self.LeaguesDetailsModelSubject.onNext(res.leagues)
                
            case .failure(_):
                self.loadingBehavior.accept(false)
                print("Error")
            }
        }
        
    }
    
}
