//
//  ViewController.swift
//  GithubUsers
//
//  Created by Evan Masterson on 21/09/2020.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var textfield: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Home"
  }

  @IBAction func didTapSearchButton(_ sender: Any) {
    makeSearch()
  }

  @IBAction func textFieldDidEndOnExit(_ sender: Any) {
    makeSearch()
  }

  // MARK: - Private helper functions

  private func makeSearch() {
    SearchService().search(userName: textfield.text!) { (result, error) in
      if result != nil {
        self.navigateWithResults(results: result!.items!)
      } else {
        self.displayAlert(error: error!)
      }
    }
  }

  private func navigateWithResults(results: [User]) {
    DispatchQueue.main.async {
      let listViewController = ListTableViewController()
      listViewController.data = results
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

