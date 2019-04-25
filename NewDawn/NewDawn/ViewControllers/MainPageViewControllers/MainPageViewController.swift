//
//  MainPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/4.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit


class MainPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MainPageViewModel!
    var user_profiles: Array<UserProfile>!

    override func viewDidLoad() {
        super.viewDidLoad()
            NotificationCenter.default.addObserver(self, selector: #selector(self.likeButtonTappedOnPopupModal), name: NSNotification.Name(rawValue: "likeButtonTappedOnPopupModal"), object: nil)
        user_profiles = UserProfileBuilder.getUserProfileListFromLocalStorage()
//        user_profiles = [
//            UserProfile(data: USER_DUMMY_DATA[0]),
//            UserProfile(data: USER_DUMMY_DATA[1])
//        ]
        if ProfileIndexUtil.noMoreProfile(profiles: user_profiles) || TimerUtil.isOutdated() {
            // Go to the ending page if no profile is available in local storage or is outdated
            // The ending page will handle profile fetch and refresh the main page automatically
            self.performSegue(withIdentifier: "mainPageEnd", sender: nil)
        } else {
            // Prepare the current profile view
            viewModel = MainPageViewModel(userProfile: user_profiles[ProfileIndexUtil.loadProfileIndex()])
            tableView.dataSource = viewModel
            tableView.delegate = viewModel
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.backgroundColor = UIColor.init(red: 251, green: 249, blue: 246, alpha: 1)
            navigationItem.hidesBackButton = true
        }
    }
    
    func performSegueToNextProfile(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        if ProfileIndexUtil.reachLastProfile(profiles: user_profiles) {
            self.performSegue(withIdentifier: "mainPageEnd", sender: nil)
        } else {
            ProfileIndexUtil.updateProfileIndex()
            self.performSegue(withIdentifier: "mainPageSelf", sender: nil)
        }
    }
    
    @objc func likeButtonTappedOnPopupModal(notif: NSNotification) {
        self.performSegueToNextProfile(notif)
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        // The profile is skipped
        self.performSegueToNextProfile(sender)
    }
    
}
