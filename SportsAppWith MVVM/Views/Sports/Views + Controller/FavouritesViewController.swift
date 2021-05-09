//
//  FavouritesViewController.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 08/05/2021.
//

import UIKit
import RxCocoa
import RxSwift
import CoreData

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let CellIdetifierCell = "Cell"
    let NibFileName = "LeagueCell"
    
    let coreDataViewModel = FavouritesViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        subscribeToResponse()
        subscribeToResponseConnection()
        subscribeToBranchSelection()
        subscribeData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveTestNotification), name: NSNotification.Name(rawValue: "Added"), object: nil)
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: NibFileName , bundle: nil), forCellReuseIdentifier: CellIdetifierCell)
    }
    
    func subscribeToResponseConnection() {
        coreDataViewModel.SetConnection()
    }
    
    func subscribeToResponse() {
        self.coreDataViewModel.SavedModelSubjectObserval
            .bind(to: self.tableView
            .rx
            .items(cellIdentifier: self.CellIdetifierCell,
                   cellType: LeagueCell.self)) { row, branch, cell in
                cell.LeagueNameLabel.text = branch.value(forKeyPath: "leaguetitle") as? String
        }
        .disposed(by: disposeBag)
    }
    
    func subscribeToBranchSelection() {
        Observable
        .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(NSManagedObject.self))
        .bind { [weak self] selectedIndex, branch in
            
            guard let self = self else { return }
            
            if self.coreDataViewModel.ConnectionBehaviour.value == true {
                
                let storyBoard = UIStoryboard(name: "LeaguesView", bundle: nil)
                let next = storyBoard.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as! LeaguesDetailsViewController
                next.PickedLeagueID = branch.value(forKeyPath: "leagueid") as! String
                next.PickedLeagueName = branch.value(forKey: "leaguetitle") as! String
                next.modalPresentationStyle = .fullScreen
                self.present(next, animated: true)
            
            }
            else {
                self.createAlert(Title: "Error", Mess: "There is no internet Connection", ob: self)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func subscribeData() {
        coreDataViewModel.fetchAllData()
    }

    
    @objc func receiveTestNotification() {
        subscribeData()
    }
}
