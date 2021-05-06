//
//  HomeViewModel.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    private var HomeModelSubject = PublishSubject<[HomeModel]>()
        
    var HomeModelObservable: Observable<[HomeModel]> {
        return HomeModelSubject
    }
    
    func getData() {
        
        let StringArr = [
            """
     Our App helps user to know information about
     any leagues you want
     """ ,
            """
     Show Details For your favorite team,
     encourage him with you know about it all information
     """,
            """
     Sea olds results in your favorite league,
     see your team results
     """
                  ]
        let ImageArr = ["AllSports","Barchelona","ResultsImage"]
        
        var homeModel = Array<HomeModel>()
        
        for i in 0..<3 {
            let ob = HomeModel(TitleName: StringArr[i], TitleImage: ImageArr[i])
            homeModel.append(ob)
        }
        
        HomeModelSubject.onNext(homeModel)
        
    }
    
}
