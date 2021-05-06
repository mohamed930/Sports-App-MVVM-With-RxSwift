//
//  SportsViewModel.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import Foundation
import RxCocoa
import RxSwift

class SportsViewModel {
    
    private var SportsModelSubject = PublishSubject<[SportsModel]>()
    
    
    var SportsModelSubjectObserval:Observable<[SportsModel]> {
        return SportsModelSubject
    }
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    func GetSports() {
        
        loadingBehavior.accept(true)
        
        let ob = SportsAPI()
        
        ob.GetAllSports { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let ob):
                self.loadingBehavior.accept(false)
                
                guard let ob = ob else { return }
                
                self.SportsModelSubject.onNext(ob.sports)
                
            case .failure(let error):
                self.loadingBehavior.accept(false)
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
        
    }
    
}
