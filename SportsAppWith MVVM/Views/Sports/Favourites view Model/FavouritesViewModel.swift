//
//  FavouritesViewModel.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 08/05/2021.
//

import Foundation
import Reachability
import RxCocoa
import RxSwift
import CoreData

class FavouritesViewModel {
    
    let reachability = try! Reachability()
    
    var ConnectionBehaviour = BehaviorRelay<Bool>(value: false)
    
    private var SavedLeaguesModelSubject = PublishSubject<[NSManagedObject]>()
    
    var SavedModelSubjectObserval:Observable<[NSManagedObject]> {
        return SavedLeaguesModelSubject
    }
    
    func SetConnection () {
        
        self.ConnectionBehaviour.accept(false)
        
        reachability.whenReachable = { reachability in
                    
            if reachability.connection == .wifi || reachability.connection == .cellular {
                print("Connection Successfully")
                self.ConnectionBehaviour.accept(true)
            }
        }
        reachability.whenUnreachable = { _ in
            print("Connection False")
            self.ConnectionBehaviour.accept(false)
        }
        
       do {
           try reachability.startNotifier()
       } catch {
           print("Unable to start notifier")
       }
        
    }
    
    func fetchAllData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Leagues")
        do {
           self.SavedLeaguesModelSubject.onNext(try context.fetch(fetchRequest))
           
        } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
