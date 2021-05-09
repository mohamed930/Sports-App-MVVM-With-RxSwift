//
//  CoreDataViewModel.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 07/05/2021.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class CoreDataViewModel {
    
    let disposeBase = DisposeBag()
    
    private var SavedLeaguesModelSubject = PublishSubject<[NSManagedObject]>()
    
    var SavedModelSubjectObserval:Observable<[NSManagedObject]> {
        return SavedLeaguesModelSubject
    }
    
    var coredataModel: CoreDataModel? = nil
    
    var currentIdexPath = BehaviorRelay<Int>(value: 0)
    
     var PickedId = BehaviorRelay<String>(value: "")
    
    var AddingBehavior = BehaviorRelay<Bool>(value: false)
    
    func SaveData() {
        
        AddingBehavior.accept(false)
        
        guard let coredataModel = coredataModel else {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Leagues", in: context)!
        let league = NSManagedObject(entity: entity,insertInto: context)
        
        league.setValue(coredataModel.leagueID , forKeyPath: "leagueid")
        league.setValue(coredataModel.leagueTitle , forKeyPath: "leaguetitle")
        
        do {
            try context.save()
            print("Added Successfully!")
            AddingBehavior.accept(true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Added"), object: self)
        } catch let error as NSError {
           print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func LoadLove () {
        
        self.AddingBehavior.accept(false)
        
        self.SavedLeaguesModelSubject.subscribe(onNext: {
            
           [weak self] no in
            
            guard let self = self else { return }
            
            var count = 0
            for i in no {
                print("Started Loop!")
                if i.value(forKeyPath: "leagueid") as? String == self.PickedId.value {
                    self.AddingBehavior.accept(true)
                    self.currentIdexPath.accept(count)
                    break
                }
                count += 1
            }
            
        }).disposed(by: disposeBase)
        
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Leagues")
         do {
            self.SavedLeaguesModelSubject.onNext(try context.fetch(fetchRequest))
            
         } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
         }
    }
    
    func DeleteData () {
        
        self.AddingBehavior.accept(true)
        
        self.SavedLeaguesModelSubject.subscribe(onNext: {
            [weak self] no in

            guard let self = self else { return }

            context.delete(no[self.currentIdexPath.value] as NSManagedObject)

            do {
                try context.save()
                print("Deleted Successfully!")
                self.AddingBehavior.accept(false)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Added"), object: self)
            } catch let error as NSError {
               print("Could not save. \(error), \(error.userInfo)")
            }
            
        }).disposed(by: disposeBase)
        
        LoadLove()
        
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
