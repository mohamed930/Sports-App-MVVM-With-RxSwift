//
//  LeaguesDetailsViewController.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class LeaguesDetailsViewController: UIViewController {
    
    @IBOutlet weak var LeagueLogo: UIImageView!
    @IBOutlet weak var LeagueTitleLabel: CustomUILabel!
    @IBOutlet weak var UpcommingCV: UICollectionView!
    @IBOutlet weak var EventsCV: UICollectionView!
    @IBOutlet weak var TeamsCV: UICollectionView!
    @IBOutlet weak var LoveButton: UIButton!
    @IBOutlet weak var ButtonBack: UIButton!

    let leaguesDetailsViewModel = LeaguesDetailsViewModel()
    let eventsViewModel = LastEventsViewModel()
    let teamsViewModel  = AllTeamsViewModel()
    let coreDataViewModel = CoreDataViewModel()
    let disposeBag = DisposeBag()
    var PickedLeagueID = String()
    var PickedLeagueName = String()
    var LinkYoutube: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaguesDetailsViewModel.PickedLeagueID.accept(PickedLeagueID)
        eventsViewModel.PickedLeagueID.accept(PickedLeagueID)
        teamsViewModel.PickedLeagueTitleName.accept(PickedLeagueName)

        RegesterCollectionView()
        subscribeToLoading()
        subscribeToResponse()
        subscribeGetData()
        print("F: \(self.teamsViewModel.PickedLeagueTitleName.value)")
        subscribeToResponseData()
        subscribeToGetDataTeams()
        subscribeBackButton()
        touchsubscribeTeam()
        
        coreDataViewModel.PickedId.accept(self.PickedLeagueID)
        coreDataViewModel.LoadLove()
        subscribeToLoveStatus()
        subscribeLoveButton()
        
    }
    
    func RegesterCollectionView() {
        UpcommingCV.delegate = self
        EventsCV.delegate    = self
        TeamsCV.delegate     = self
        UpcommingCV.register(UINib(nibName: "UpcommingCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        EventsCV.register(UINib(nibName: "ResultCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        TeamsCV.register(UINib(nibName: "TeamsCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    func subscribeToLoading() {
        leaguesDetailsViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.ShowProgress(Title: "Please Wait")
            } else {
                self.DismissProgress()
            }
        }).disposed(by: disposeBag)
        
//        eventsViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
//            if isLoading {
//                self.ShowProgress(Title: "Please Wait")
//            } else {
//                self.DismissProgress()
//            }
//        }).disposed(by: disposeBag)
        
        teamsViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.ShowProgress(Title: "Please Wait")
            } else {
                self.DismissProgress()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToLoveStatus() {
        coreDataViewModel.AddingBehavior.subscribe(onNext: { (isLoved) in
            if isLoved {
                self.LoveButton.setBackgroundImage(UIImage(named: "heart_red"), for: .normal)
            } else {
                self.LoveButton.setBackgroundImage(UIImage(named: "BTNLove"), for: .normal)
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        
        // Upcomming Events.
        self.eventsViewModel.EventsModelSubjectObserval
            .bind(to: self.UpcommingCV
            .rx
            .items(cellIdentifier: "Cell",
                   cellType: UpcommingCell.self)) { row, branch, cell in
                
                cell.configureCell(branch: branch)
                
            }.disposed(by: disposeBag)
        
        // Last Events.
        self.eventsViewModel.EventsModelSubjectObserval
            .bind(to: self.EventsCV
            .rx
            .items(cellIdentifier: "Cell",
                   cellType: ResultCell.self)) { row, branch, cell in
                
                cell.ConfigureCell(branch: branch)
                
                
            }.disposed(by: disposeBag)
        
        // All Teams In A League.
        self.teamsViewModel.TeamsModelSubjectObserval
            .bind(to: self.TeamsCV
            .rx
            .items(cellIdentifier: "Cell",
                   cellType: TeamsCell.self)) { row, branch, cell in
                
                cell.confingureCell(branch: branch)
                
            }.disposed(by: disposeBag)
        
    }
    
    func subscribeGetData() {
        leaguesDetailsViewModel.GetLeagueData()
        eventsViewModel.GetLeagueData()
    }
    
    func subscribeToGetDataTeams() {
        teamsViewModel.GetLeagueData()
    }
    
    func subscribeToResponseData() {
        
        leaguesDetailsViewModel.LeaguesDetailsModelSubjectObserval.subscribe(onNext: {
            self.LeagueTitleLabel.text =  $0.first?.strLeagueName
            self.LeagueLogo.kf.setImage(with:URL(string: ($0.first?.strBadge)!))
            
            if let link = $0.first?.strYoutube {
                self.LinkYoutube = link
            }
            else {
                self.LinkYoutube = "No Link"
            }
            
            // Add TapGeuster
            var tab = UITapGestureRecognizer()
            tab = UITapGestureRecognizer(target: self, action: #selector(self.gotoLink(tapGestureRecognizer:)))
            tab.numberOfTapsRequired = 1
            tab.numberOfTouchesRequired = 1
            self.LeagueTitleLabel.isUserInteractionEnabled = true
            self.LeagueTitleLabel.addGestureRecognizer(tab)
            
        }).disposed(by: disposeBag)
    }
    
    func subscribeBackButton() {
        ButtonBack.rx.tap
           .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self](_) in
               guard let self = self else { return }
               self.dismiss(animated: true)
       }).disposed(by: disposeBag)
    }
    
    func subscribeLoveButton() {
        LoveButton.rx.tap
           .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self](_) in
               guard let self = self else { return }
            
            if self.coreDataViewModel.AddingBehavior.value == true {
                print("Entered here")
                self.coreDataViewModel.DeleteData()
            }
            else {
                let ob = CoreDataModel(leagueID: self.PickedLeagueID, leagueTitle: self.PickedLeagueName)
                self.coreDataViewModel.coredataModel = ob
                self.coreDataViewModel.SaveData()
            }
            
               
       }).disposed(by: disposeBag)
    }
    
    func touchsubscribeTeam() {
        
        Observable
        .zip(TeamsCV.rx.itemSelected, TeamsCV.rx.modelSelected(AllTemasModel.self))
        .bind { [weak self] selectedIndex, branch in
            
            guard let self = self else{ return }
            
            let story = UIStoryboard(name: "TeamsStoryboard", bundle: nil)
            let next = story.instantiateViewController(withIdentifier: "TeamsDetailsViewController") as! TeamsDetailsViewController
            
            next.PickedTeamId = branch.idTeam
            next.modalPresentationStyle = .fullScreen
            
            self.present(next, animated: true)
            
            //print(selectedIndex, branch.sportName)
        }
        .disposed(by: disposeBag)
        
    }
    
    @objc func gotoLink(tapGestureRecognizer: UITapGestureRecognizer) {
//     print("Link Youtube: \(self.LinkYoutube)")
        
        if let youtube = LinkYoutube {
            let story = UIStoryboard(name: "LeaguesView", bundle: nil)
            let next = story.instantiateViewController(withIdentifier: "YoutubeViewController") as! YoutubeViewController
        
            next.youtubeLink = youtube
            //next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true)
        }
        else {
            print("There is no link")
        }
    }
}

extension LeaguesDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
                IndexPath) -> CGSize {
            
        if collectionView.tag == 1 {
            return CGSize(width: 189 , height: 75)
        }
        else if collectionView.tag == 2 {
            return CGSize(width: EventsCV.frame.width - 10 , height: 90)
        }
        else {
            let w1 = TeamsCV.frame.width - (15 * 2)
            let cell_width = (w1 - (15 * 2)) / 4
            
            return CGSize(width: cell_width, height: 75)
        }
        
    }
    
}
