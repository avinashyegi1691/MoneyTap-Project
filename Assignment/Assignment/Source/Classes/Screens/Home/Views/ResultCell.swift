//
//  HomeViewModel.swift
//  Assignment
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 xyz. All rights reserved.
//

import Foundation
import UIKit

class ResultCell:UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    func updateUI(viewModel: ResultViewModel){
        self.selectionStyle = .none
        titleLable.text = viewModel.titleText
        descriptionLabel.text = viewModel.descriptionText

        viewModel.downloadImage {[weak self] (result) in
            guard let weakSelf = self else {return}
            
            switch result {
                case .success:
                    DispatchQueue.main.async {
                        weakSelf.thumbnailImageView.image = viewModel.image
                    }
                case .failure(_):
                    break
                    //Set default image
            }
        }
    }
}


