//
//  LeaguesViewModel.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import Foundation
import RxCocoa
import RxSwift

class LeaguesViewModel {
    
    var PickedSportName = BehaviorRelay<String>(value: "")
    
    var FilteredArr = Array<LeaguesModel>()
    
    private var LeaguesModelSubject = PublishSubject<[LeaguesModel]>()
    
    var LeaguesModelSubjectObserval:Observable<[LeaguesModel]> {
        return LeaguesModelSubject
    }
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    func GetLeagues() {
        
        let ob = LeaguesAPI()
        
        loadingBehavior.accept(true)
        
        ob.GetAllLeagues { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let res):
                self.loadingBehavior.accept(false)
                
                guard let res = res else {
                    return
                }
                
                for i in (res.leagues) {
                                    
                    if i.SportType == self.PickedSportName.value {
                        self.FilteredArr.append(i)
                    }

                }
                
                self.LeaguesModelSubject.onNext(self.FilteredArr)
                
            case .failure(let error):
                self.loadingBehavior.accept(false)
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
            
        }
        
    }
    
}
