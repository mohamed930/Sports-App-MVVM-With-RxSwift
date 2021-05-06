//
//  ViewController.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var PaggineControl: UIPageControl!
    @IBOutlet weak var NextButton: UIButton!
    
    let ReuseIdentifier = "Cell"
    let ReuseFileName   = "WelcomCell"
    
    let disposeBag = DisposeBag()
    let homeViewModel = HomeViewModel()
    
    var currentItem = IndexPath(row: 0, section: 0)
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MakeRound(myView: NextButton, v: .layerMinXMinYCorner)
        
        
        setupCollectionView()
        subscribeToResponse()
        getDataWelcome()
        subscribeToNextButton()
    }
    
    func setupCollectionView () {
        collectionView.register(UINib(nibName: ReuseFileName, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier)
        collectionView.delegate = self
    }
    
    func subscribeToResponse() {
        self.homeViewModel.HomeModelObservable
            .bind(to: self.collectionView
                .rx
                .items(cellIdentifier: ReuseIdentifier,
                       cellType: WelcomCell.self)) { row, branch, cell in
                        print(row)
                cell.TitleLabel.text = branch.TitleName
                cell.CoverImageView.image = UIImage(named: branch.TitleImage)
        }
        .disposed(by: disposeBag)
    }
    
    func getDataWelcome() {
        homeViewModel.getData()
    }
    
    func subscribeToNextButton() {
        NextButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                
                self.collectionView.reloadData()
                
                self.count += 1
                print("BeforeID: \(self.currentItem.row)")
                self.currentItem.row += 1
                print("ID: \(self.currentItem.row)")
                
        //        var nextItem = IndexPath(item: count, section: 0)
                
                print("F1 \(self.currentItem.row)")
                let nextItem = IndexPath(row: self.currentItem.row, section: 0)
                
                if nextItem.row == 2 {
                    self.NextButton.setTitle("let's do it", for: .normal)
                    

                    self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
                }
                
                else if nextItem.row == 3 {
                    print("Finished!")
                    
                    let story = UIStoryboard(name: "SportsView", bundle: nil)
                    let next  = story.instantiateViewController(withIdentifier: "HomeTapBar")
                    next.modalPresentationStyle = .fullScreen
                    self.present(next, animated: true, completion: nil)
                    
                }
                else {
                    self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
                }
                
                
                
        }).disposed(by: disposeBag)
    }
    
    


}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.currentItem = indexPath
        if indexPath.row == 2 {
            print("Finished")
            NextButton.setTitle("let's do it", for: .normal)
        }
        else {
            NextButton.setTitle("Next", for: .normal)
        }
        self.PaggineControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
        IndexPath) -> CGSize {
        
         return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

