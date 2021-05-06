//
//  LastEventsViewModel.swift
//  Sports-App
//
//  Created by Mohamed Ali on 3/28/21.
//

import Foundation
import RxCocoa
import RxSwift


class LastEventsViewModel {
    
    var PickedLeagueID = BehaviorRelay<String>(value: "")
    
    private var EventsModelSubject = PublishSubject<[EventsModel]>()
    
    var EventsModelSubjectObserval:Observable<[EventsModel]> {
        return EventsModelSubject
    }
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    func GetLeagueData() {
        
        loadingBehavior.accept(true)
        
        let ob = EventsAPI()
        
        ob.GetAllEvents(id: PickedLeagueID.value) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            
            case .success(let res):
                guard let res = res else { return }
                
                self.EventsModelSubject.onNext(res.events)
                
                
            case .failure(_):
                self.loadingBehavior.accept(false)
                print("Error")
            }
        }
    }
}
