//
//  ListTableViewController.swift
//  GithubUsers
//
//  Created by Evan Masterson on 22/09/2020.
//

import UIKit

class ListTableViewController: UITableViewController {

  var data: [User] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "User List"

    let cellNib = UINib.init(nibName: "ListTableViewCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "listCell")

    navigationItem.rightBarButtonItem = self.editButtonItem
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
    cell.showsReorderControl = true
    cell.configureWithModel(model: data[indexPath.row])

    return cell
  }

  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
      data.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }

  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movingObject = data[sourceIndexPath.row]
    data.remove(at: sourceIndexPath.row)
    data.insert(movingObject, at: destinationIndexPath.row)
  }

  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }

}