//
//  ViewController.swift
//  TestApp
//
//  Created by Yurii Sushko on 14.09.2018.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var likesCollectionView: UICollectionView?
    @IBOutlet weak var commentsCollectionView: UICollectionView?
    @IBOutlet weak var marksCollectionView: UICollectionView?
    @IBOutlet weak var repostsCollectionView: UICollectionView?
    @IBOutlet weak var bookMarksCollectionView: UICollectionView?
    
    @IBOutlet weak var viewsCountLabel: UILabel?
    @IBOutlet weak var likesCountLabel: UILabel?
    @IBOutlet weak var commentsCountLabel: UILabel?
    @IBOutlet weak var marksCountLabel: UILabel?
    @IBOutlet weak var repostsCountLabel: UILabel?
    @IBOutlet weak var bookMarksLabel: UILabel?
  
    // MARK: Properties
    
    var viewsPersons = [Person]()
    var likesPersons = [Person]()
    var commentsPersons = [Person]()
    var marksPersons = [Person]()
    var repostersPersons = [Person]()
    var bookmarksPersons = [Person]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getIformation()
    }

    // MARK: PrivateFunctions
    
    private func getIformation() {
        loadingView()
        getLikesPost()
        getComments()
        getMarks()
        getReposts()
        getBookMarks()
    }
    
    private func getLikesPost() {
        InternetService.shared.getLikersPost { [weak self] (count, persons) in
            self?.likesPersons = persons
            DispatchQueue.main.async {
                self?.likesCountLabel?.text = Constants.likes + String(count)
                self?.likesCollectionView?.reloadData()
            }
        }
    }
    
    private func getComments() {
        InternetService.shared.getCommentators { [weak self] (count, persons) in
            self?.commentsPersons = persons
            DispatchQueue.main.async {
                self?.commentsCountLabel?.text = Constants.comments + String(count)
                self?.commentsCollectionView?.reloadData()
            }
        }
    }
    
    private func getMarks() {
        InternetService.shared.getMarks { [weak self] (count, persons) in
            self?.marksPersons = persons
            DispatchQueue.main.async {
                self?.marksCountLabel?.text = Constants.marks + String(count)
                self?.marksCollectionView?.reloadData()
            }
        }
    }
    
    private func getReposts() {
        InternetService.shared.getReposters { [weak self] (count, persons) in
            self?.marksPersons = persons
            DispatchQueue.main.async {
                self?.repostsCountLabel?.text = Constants.reposts + String(count)
                self?.repostsCollectionView?.reloadData()
            }
        }
    }
    
    private func getBookMarks() {
        InternetService.shared.getPostInfo { [weak self] (viewsCount, bookMarksCount) in
            DispatchQueue.main.async {
                self?.viewsCountLabel?.text = Constants.views + String(viewsCount)
                self?.bookMarksLabel?.text = Constants.bookmarks + String(bookMarksCount)
                JustHUD.shared.hide()
            }
        }
    }
    
    private func loadingView() {
        JustHUD.shared.showInView(view: self.view)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    // MARK:  UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return likesPersons.count
        case 1:
            return commentsPersons.count
        case 2:
            return marksPersons.count
        case 3:
            return repostersPersons.count
        case 4:
            return bookmarksPersons.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCell", for: indexPath) as? PersonCollectionViewCell
        
        switch collectionView.tag {
        case 0:
            cell?.person = likesPersons[indexPath.row]
        case 1:
            cell?.person = commentsPersons[indexPath.row]
        case 2:
            cell?.person = marksPersons[indexPath.row]
        case 3:
            cell?.person = repostersPersons[indexPath.row]
        case 4:
            cell?.person = bookmarksPersons[indexPath.row]
        default:
            break
        }

        return cell ?? UICollectionViewCell()
    }
    
}

extension ViewController {
    
    private struct Constants {
        static let likes = "Лайки: "
        static let comments = "Комментарии: "
        static let marks = "Отметки: "
        static let reposts = "Репосты: "
        static let views = "Просмотры: "
        static let bookmarks = "Закладки: "
    }
    
}

