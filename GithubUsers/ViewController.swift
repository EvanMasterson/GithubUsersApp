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
    self.title = "Home"
  }

  @IBAction func didTapSearchButton(_ sender: Any) {
    SearchService().search(userName: textfield.text!) { (result, error) in
      if result != nil {
        print(result!.items)
      } else {
        print(error!)
      }
    }
  }

}

