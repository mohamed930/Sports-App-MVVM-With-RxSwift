//
//  TeamsDetailsViewController.swift
//  SportsAppWith MVVM
//
//  Created by Mohamed Ali on 05/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class TeamsDetailsViewController: UIViewController {
    
    @IBOutlet weak var CoverImageView: UIImageView!
    @IBOutlet weak var TeamBadgeImageView: UIImageView!
    @IBOutlet weak var TeamTitleLabel: UILabel!
    @IBOutlet weak var StadiumLabel: UILabel!
    @IBOutlet weak var LeagueNameLabel: UILabel!
    @IBOutlet weak var DetailsTextArea: UITextView!
    @IBOutlet weak var BTNBack: UIButton!
    @IBOutlet weak var BTNFacebook: UIButton!
    @IBOutlet weak var BTNTwitter: UIButton!
    @IBOutlet weak var BTNInstegram: UIButton!
       
    // MARK:- TODO:- Instialise new variable HERE:-
    
    var PickedTeamId = String()
    
    let teamviewModel = TeamDetailsViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        teamviewModel.PickedTeamID.accept(PickedTeamId)
        subscribeToLoading()
        GetTeamDetails()
        touchDataResponse()
        subscribeBackButton()
        subscribeFacbookButton()
        subscribeTwitterButton()
        subscribeInstaButton()
    }
    
    func subscribeToLoading() {
        teamviewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.ShowProgress(Title: "Please Wait")
            } else {
                self.DismissProgress()
            }
        }).disposed(by: disposeBag)
    }
    
    func GetTeamDetails() {
        teamviewModel.GetLeagueData()
    }
    
    func touchDataResponse () {
        teamviewModel.TeamModelSubjectObserval.subscribe(onNext: {
            
            self.teamviewModel.PickedFacebook.accept(($0.first!.strFacebook ?? "No URL"))
            self.teamviewModel.PickedTwitter.accept(($0.first!.strTwitter ?? "No URL"))
            self.teamviewModel.PickedInstegram.accept(($0.first!.strInstagram ?? "No URL"))
            
            
            self.TeamTitleLabel.text = $0.first!.strTeam.localizedUppercase
            self.StadiumLabel.text = $0.first!.strStadium
            self.LeagueNameLabel.text = $0.first!.strLeague
            self.DetailsTextArea.text = $0.first!.strDescriptionEN
       
//            self.LinkFaceBook = ($0.first!.strFacebook ?? "No URL")
//            self.LinkTwitter = ($0.first!.strTwitter ?? "No URL")
//            self.LinkIntegram = ($0.first!.strInstagram ?? "No URL")
            
            if $0.first!.strTeamFanart1 == "" || $0.first!.strTeamFanart1 == "NO Image" || $0.first!.strTeamFanart1 == nil {
                               
                self.CoverImageView.image = UIImage(named: "No_image1")
                self.BTNBack.setBackgroundImage(UIImage(named: "backBlack"), for: .normal)
                
                self.TeamBadgeImageView.kf.setImage(with: URL(string: ($0.first!.strTeamBadge)!))
            }
            else {
                
                self.CoverImageView.kf.setImage(with:URL(string: ($0.first!.strTeamFanart1 ?? "NO Image")))
                self.TeamBadgeImageView.kf.setImage(with: URL(string: ($0.first!.strTeamBadge)!))
                
            }
            
        }).disposed(by: disposeBag)
    }
    
    func subscribeBackButton() {
        BTNBack.rx.tap
           .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self](_) in
               guard let self = self else { return }
               self.dismiss(animated: true)
       }).disposed(by: disposeBag)
    }
    
    func subscribeFacbookButton() {
        BTNFacebook.rx.tap
           .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self](_) in
               guard let self = self else { return }
            
            self.teamviewModel.CheckLinkAndViewIt(url: self.teamviewModel.PickedFacebook.value , delegate: self)
            
       }).disposed(by: disposeBag)
    }
    
    func subscribeTwitterButton() {
        BTNTwitter.rx.tap
           .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self](_) in
               guard let self = self else { return }
            
            self.teamviewModel.CheckLinkAndViewIt(url: self.teamviewModel.PickedTwitter.value , delegate: self)
            
       }).disposed(by: disposeBag)
    }
    
    func subscribeInstaButton() {
        BTNInstegram.rx.tap
           .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
           .subscribe(onNext: { [weak self](_) in
               guard let self = self else { return }
            
            self.teamviewModel.CheckLinkAndViewIt(url: self.teamviewModel.PickedInstegram.value , delegate: self)
            
       }).disposed(by: disposeBag)
    }

}
