//
//  ViewController.swift
//  GithubUsers
//
//  Created by Evan Masterson on 21/09/2020.
//

import UIKit
import Lottie

class ViewController: UIViewController {

  @IBOutlet weak private var textfield: UITextField!
  @IBOutlet weak private var animationContainer: UIView!

  private var loadingAnimationView: AnimationView?

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Home"
    configureView()
  }

  @IBAction func didTapSearchButton(_ sender: Any) {
    makeSearch()
  }

  @IBAction func textFieldDidEndOnExit(_ sender: Any) {
    makeSearch()
  }

  // MARK: - Private helper functions

  private func configureView() {
    loadingAnimationView = AnimationView(name: "loading")
    loadingAnimationView?.frame = animationContainer.bounds
    loadingAnimationView?.loopMode = .loop
    loadingAnimationView?.backgroundBehavior = .pauseAndRestore
    animationContainer.addSubview(loadingAnimationView!)
  }

  private func makeSearch() {
    playAnimation(play: true)

    let searchText = textfield.text!
    SearchService().search(userName: searchText) { [weak self] (result, error) in
      if result != nil {
        self?.navigateWithResults(results: result!.items!, initialSearch: searchText)
      } else {
        self?.displayAlert(error: error!)
      }
      self?.playAnimation(play: false)
    }
  }

  private func navigateWithResults(results: [User], initialSearch: String) {
    DispatchQueue.main.async {
      let listViewController = ListTableViewController(datasource: results, initialSearch: initialSearch)
      self.navigationController?.pushViewController(listViewController, animated: true)
    }
  }

  private func displayAlert(error: String) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
      let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
      alertController.addAction(action)
      self.present(alertController, animated: true, completion: nil)
    }
  }

  private func playAnimation(play: Bool) {
    let animationViewAlpha: CGFloat = play ? 1.0 : 0.0

    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.5) {
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

