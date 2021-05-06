//
//  SportsViewController.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class SportsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ButtonAction: UIButton!
    @IBOutlet weak var SearchWidth: NSLayoutConstraint!
    @IBOutlet weak var SportsLeading: NSLayoutConstraint!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SportsTrailing: NSLayoutConstraint!
    @IBOutlet weak var ContainerView: UIView!
    
    let sportsIdetifierCell = "Cell"
    let sportsNibFileCell = "SportsCell"
    let disposeBag = DisposeBag()
    let sportsViewModel = SportsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        RegseterCollectionView()
        subscribeToLoading()
        subscribeToResponse()
        subscribeToBranchSelection()
        getSports()
        subscriveButtonSearch()
    }
    
    func subscriveButtonSearch () {
        ButtonAction.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                
                if self.SearchWidth.constant == 0 {
                    UIView.animate(withDuration: 0.7) {
                        self.SearchWidth.constant = (self.ContainerView.layer.frame.width) - 40
                        self.SportsLeading.constant = 30
                        self.SportsTrailing.constant = 10
                        self.PlaceHolder(textField: self.SearchTextField, PlaceHolder: "Enter Sport name", Color: UIColor.white)
                        self.SearchTextField.becomeFirstResponder()
                        self.view.layoutIfNeeded()
                    }
                }
                else {
                    print("Search is Done!")
                }
                
            }).disposed(by: disposeBag)
    }
    
    func RegseterCollectionView() {
        
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: sportsNibFileCell, bundle: nil), forCellWithReuseIdentifier: sportsIdetifierCell)
        
    }
    
    func subscribeToLoading() {
        sportsViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.ShowProgress(Title: "Please Wait")
            } else {
                self.DismissProgress()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        self.sportsViewModel.SportsModelSubjectObserval
            .bind(to: self.collectionView
                .rx
                .items(cellIdentifier: sportsIdetifierCell,
                       cellType: SportsCell.self)) { row, branch, cell in
                    cell.SportNameLabel.text = branch.sportName
                    DispatchQueue.main.async {
                        cell.SportImageView.kf.setImage(with:URL(string: branch.SportThumbnail))
                        
                    }
        }
        .disposed(by: disposeBag)
    }
    
    func subscribeToBranchSelection() {
            Observable
                .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(SportsModel.self))
                .bind { [weak self] selectedIndex, branch in
                    
                    guard let self = self else{ return }
                    
                    let story = UIStoryboard(name: "LeaguesView", bundle: nil)
                    let next = story.instantiateViewController(withIdentifier: "LeaguesViewController") as! LeaguesViewController
                    
                    next.PickedSportName = branch.sportName
                    next.modalPresentationStyle = .fullScreen
                    
                    self.present(next, animated: true)
                    
                    //print(selectedIndex, branch.sportName)
            }
            .disposed(by: disposeBag)
        }
    
    func getSports() {
        sportsViewModel.GetSports()
    }
    
    func DismissKeyPad() {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.7) {
            self.SearchWidth.constant = 0
            self.SportsLeading.constant = 166
            self.SportsTrailing.constant = 151.67
            //self.PlaceHolder(textField: self.SearchTextField, PlaceHolder: "Enter Sport name", Color: UIColor.white)
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.DismissKeyPad()
    }
    
}

extension SportsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
                IndexPath) -> CGSize {
        
                
        let w1 = collectionView.frame.width - (22 * 2)
        let cell_width = (w1 - (22 * 2)) / 2
        
        return CGSize(width: cell_width, height: 165)
    }
}

extension SportsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.DismissKeyPad()
        return true
    }
}
