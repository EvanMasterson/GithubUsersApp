//
//  DetailViewController.swift
//  GithubUsers
//
//  Created by Evan Masterson on 23/09/2020.
//

import UIKit
import Lottie

class DetailViewController: UIViewController {

  @IBOutlet weak private var infoView: UIView!
  @IBOutlet weak private var animationContainer: UIView!
  @IBOutlet weak private var avatarImage: UIImageView!
  @IBOutlet weak private var nameLabel: UILabel!
  @IBOutlet weak private var followersLabel: UILabel!
  @IBOutlet weak private var followingLabel: UILabel!
  @IBOutlet weak private var reposLabel: UILabel!
  @IBOutlet weak private var gistsLabel: UILabel!

  private var model: User?
  private var loadingAnimationView: AnimationView?
  
  convenience init(model: User) {
    self.init()
    self.model = model
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    loadUserData()
  }

  private func configureView() {
    loadingAnimationView = AnimationView(name: "loading")
    loadingAnimationView?.frame = animationContainer.bounds
    loadingAnimationView?.loopMode = .loop
    loadingAnimationView?.backgroundBehavior = .pauseAndRestore
    animationContainer.addSubview(loadingAnimationView!)
    infoView.alpha = 0.0
  }

  private func loadUserData() {
    playAnimation(play: true)
    
    avatarImage.sd_setImage(with: URL(string: model!.avatarUrl), placeholderImage: UIImage(named: "github"), options: [.highPriority, .scaleDownLargeImages], context: nil)
    nameLabel.text = model!.name

    model?.fetchCounts(searchService: SearchService(), completion: { [weak self] in
      self?.followersLabel.text = String(format: "#%@", String((self?.model!.followersCount)!))
      self?.followingLabel.text = String(format: "#%@", String((self?.model!.followingCount)!))
      self?.reposLabel.text = String(format: "#%@", String((self?.model!.reposCount)!))
      self?.gistsLabel.text = String(format: "#%@", String((self?.model!.gistsCount)!))
      self?.playAnimation(play: false)
    })
  }

  private func playAnimation(play: Bool) {
    let infoViewAlpha: CGFloat = play ? 0.0 : 1.0
    let animationViewAlpha: CGFloat = play ? 1.0 : 0.0

    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.5) {
        self.infoView.alpha = infoViewAlpha
        self.animationContainer.alpha = animationViewAlpha
      }
    }

    if play {
      loadingAnimationView?.play()
    } else {
      loadingAnimationView?.stop()
    }
  }

}
