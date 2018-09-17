//
//  PersonCollectionViewCell.swift
//  TestApp
//
//  Created by Yurii Sushko on 15.09.2018.
//  Copyright © 2018 Yurii Sushko. All rights reserved.
//

import UIKit
import Kingfisher

class PersonCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var personImageView: UIImageView?
    @IBOutlet weak var personNameLabel: UILabel?
    
    // MARK: Public properties
    
    var person: Person? {
        didSet {
            self.fillCell()
        }
    }
    
    // MARK: override functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.personImageView?.image = nil
        self.personNameLabel?.text = nil
    }
    
    // MARK: Private function
    
    private func fillCell() {
        self.personNameLabel?.text = self.person?.name
        guard let imagePath = person?.imagePath else { return }
        guard let imageUrl =  URL(string: imagePath) else { return }
        let resource = ImageResource(downloadURL: imageUrl)
        self.personImageView?.kf.setImage(with: resource)
    }
    
    
    
}
