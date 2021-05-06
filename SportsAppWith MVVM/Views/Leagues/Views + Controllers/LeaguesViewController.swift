//
//  LeaguesViewController.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

class LeaguesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var LeaguesTrailing: NSLayoutConstraint!
    @IBOutlet weak var LeaguesLeading: NSLayoutConstraint!
    @IBOutlet weak var TextFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var SearchButton: UIButton!
    
    let disposeBag = DisposeBag()
    let leaguesViewModel = LeaguesViewModel()
    let CellResuseIdetifier = "Cell"
    let CellNibFileName = "LeagueCell"
    var PickedSportName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaguesViewModel.PickedSportName.accept(self.PickedSportName)

        RegseterTableView()
        subscribeToLoading()
        subscribeGetLeagues()
        subscribeToResponse()
        subscribeBackButton()
        subscribeSearchButton()
        subscribeToLeaguesSelection()
    }
    
    
    func RegseterTableView() {
        
        tableView.register(UINib(nibName: CellNibFileName, bundle: nil), forCellReuseIdentifier: CellResuseIdetifier)
        
    }
    
    func subscribeToLoading() {
        leaguesViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.ShowProgress(Title: "Please Wait")
            } else {
                self.DismissProgress()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        self.leaguesViewModel.LeaguesModelSubjectObserval
            .bind(to: self.tableView
            .rx
            .items(cellIdentifier: CellResuseIdetifier,
                   cellType: LeagueCell.self)) { row, branch, cell in
                   
                    cell.LeagueNameLabel.text = branch.LeagueTitle
                
            }.disposed(by: disposeBag)
    }
    
    func subscribeGetLeagues() {
        leaguesViewModel.GetLeagues()
    }
    
    func subscribeBackButton() {
        BackButton.rx.tap
           .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self](_) in
               guard let self = self else { return }
               self.dismiss(animated: true)
       }).disposed(by: disposeBag)
    }
    
    func subscribeSearchButton() {
        
        SearchButton.rx.tap
           .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self](_) in
               guard let self = self else { return }
            
               if self.TextFieldWidth.constant == 0 {
                    UIView.animate(withDuration: 0.7) {
                        self.TextFieldWidth.constant = (self.ContainerView.layer.frame.width) - 25
                        self.LeaguesLeading.constant = 10
                        self.LeaguesTrailing.constant = 15
                        self.PlaceHolder(textField: self.SearchTextField, PlaceHolder: "Enter League name", Color: UIColor.white)
                        self.SearchTextField.becomeFirstResponder()
                        self.view.layoutIfNeeded()
                    }
                }
            
       }).disposed(by: disposeBag)
        
    }
    
    func subscribeToLeaguesSelection() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(LeaguesModel.self))
            .bind { [weak self] selectedIndex, branch in
                
                guard let self = self else{ return }
                
                let story = UIStoryboard(name: "LeaguesView", bundle: nil)
                let next = story.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as! LeaguesDetailsViewController
                
                next.PickedLeagueID = branch.id
                next.PickedLeagueName = branch.LeagueTitle
                next.modalPresentationStyle = .fullScreen
                
                self.present(next, animated: true)
                
                //print(selectedIndex, branch.sportName)
        }
        .disposed(by: disposeBag)
    }
    
    func DismissKeyPad() {
        self.view.endEditing(true)
               
       UIView.animate(withDuration: 0.7) {
           self.TextFieldWidth.constant = 0
           self.LeaguesLeading.constant = 124
           self.LeaguesTrailing.constant = 151.67
           //self.PlaceHolder(textField: self.SearchTextField, PlaceHolder: "Enter League name", Color: UIColor.white)
           self.view.layoutIfNeeded()
       }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.DismissKeyPad()
    }
    
}

extension LeaguesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DismissKeyPad()
        return true
    }
}
