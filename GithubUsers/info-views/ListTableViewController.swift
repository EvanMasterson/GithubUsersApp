//
//  ListTableViewController.swift
//  GithubUsers
//
//  Created by Evan Masterson on 22/09/2020.
//

import UIKit

class ListTableViewController: UITableViewController, UISearchResultsUpdating {

  private var datasource: [User] = []
  private var pageCount: Int = 1
  private var initialSearch: String = ""
  private var filteredDatasource: [User] = []
  private var searchController = UISearchController()

  convenience init(datasource: [User], initialSearch: String) {
    self.init()
    self.datasource = datasource
    self.initialSearch = initialSearch
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "User List"

    configureView()
  }

  private func configureView() {
    searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.sizeToFit()

    let cellNib = UINib.init(nibName: "ListTableViewCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "listCell")
    tableView.tableHeaderView = searchController.searchBar

    navigationItem.rightBarButtonItem = self.editButtonItem
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.isActive {
      return filteredDatasource.count
    }
    return datasource.count
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
    cell.showsReorderControl = true

    let model: User
    if searchController.isActive {
      model = filteredDatasource[indexPath.row]
    } else {
      model = datasource[indexPath.row]
    }
    cell.configureWithModel(model: model)

    return cell
  }

  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
      datasource.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }

  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movingObject = datasource[sourceIndexPath.row]
    datasource.remove(at: sourceIndexPath.row)
    datasource.insert(movingObject, at: destinationIndexPath.row)
  }

  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  // Override to support selection of cell in the table view.
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model: User
    if searchController.isActive {
      model = filteredDatasource[indexPath.row]
    } else {
      model = datasource[indexPath.row]
    }
    let detailViewController = DetailViewController(model: model)

    searchController.dismiss(animated: true, completion: nil)
    navigationController?.pushViewController(detailViewController, animated: true)
  }

  // Override to support loading of additonal cells in the table view.
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastElement = datasource.count - 1
    if indexPath.row == lastElement {
      pageCount += 1
      SearchService().search(userName: initialSearch, page: pageCount) { [weak self] (result, error) in
        if result != nil {
          let newResults = result!.items!
          self?.datasource.append(contentsOf: newResults)
          DispatchQueue.main.async {
            self?.tableView.reloadData()
          }
        }
      }
    }
  }

  // MARK: - UISearchResultsUpdating

  func updateSearchResults(for searchController: UISearchController) {
    filteredDatasource.removeAll(keepingCapacity: false)

    guard let searchText = searchController.searchBar.text else { return }
    let array = datasource.filter { (user) -> Bool in
      return user.name.lowercased().range(of: searchText.lowercased()) != nil
    }
    filteredDatasource = array

    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

}
