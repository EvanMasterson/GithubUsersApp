//
//  ListTableViewCell.swift
//  GithubUsers
//
//  Created by Evan Masterson on 22/09/2020.
//

import UIKit
import SDWebImage

class ListTableViewCell: UITableViewCell {

  @IBOutlet weak private var nameLabel: UILabel!
  @IBOutlet weak private var avatarImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func configureWithModel(model: User) {
    let imageUrl = URL(string: model.avatarUrl)!
    nameLabel.text = model.name
    avatarImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "github"), options: [.highPriority, .scaleDownLargeImages], context: nil)
  }
    
}
