//
//  ListTableViewCell.swift
//  GithubUsers
//
//  Created by Evan Masterson on 22/09/2020.
//

import UIKit

class ListTableViewCell: UITableViewCell {

  @IBOutlet weak private var nameLabel: UILabel!
  @IBOutlet weak private var avatarImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func configureWithModel(model: User) {
    let imageUrl = URL(string: model.avatarUrl)!
    let imageData = try! Data(contentsOf: imageUrl)
    nameLabel.text = model.name
    avatarImage.image = UIImage(data: imageData)
  }
    
}
