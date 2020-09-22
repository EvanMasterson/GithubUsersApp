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
    animationContainer.isHidden = false
    loadingAnimationView?.play()

    SearchService().search(userName: textfield.text!) { (result, error) in
      if result != nil {
        self.navigateWithResults(results: result!.items!)
      } else {
        self.displayAlert(error: error!)
      }
      self.animationContainer.isHidden = true
      self.loadingAnimationView?.stop()
    }
  }

  private func navigateWithResults(results: [User]) {
    DispatchQueue.main.async {
      let listViewController = ListTableViewController(datasource: results)
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

}

