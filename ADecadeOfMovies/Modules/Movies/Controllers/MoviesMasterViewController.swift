//
//  MasterViewController.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit

class MoviesMasterViewController: UIViewController {

    // MARK: - Outlets & UI
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var detailViewController: MovieDetailViewController? = nil
    var objects = [Any]()

    private lazy var moviesViewModel = MoviesViewModel()

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed, let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Helpers
    private func setupUI() {
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MovieDetailViewController
        }
        
        navigationController?.navigationBar.shadowImage = UIImage()
        searchBar.set(textColor: .white)
        searchBar.setTextField(color: #colorLiteral(red: 0.9594017863, green: 0.3594591618, blue: 0.3556632996, alpha: 1))
        searchBar.setPlaceholder(textColor: UIColor.white.withAlphaComponent(0.3))
        searchBar.setSearchImage(color: .white)
        searchBar.setClearButton(color: .white)
        searchBar.backgroundImage = UIImage()
    }
    
    private func loadData() {
        moviesViewModel.delegate = self
        moviesViewModel.loadMovies()
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                // TODO: send movie data to the details view
//                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! MovieDetailViewController
//                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }
}


// MARK: - Table View
extension MoviesMasterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesViewModel.numberOfMovies()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = moviesViewModel.title(at: indexPath.row)
        return cell
    }
}


// MARK: - MoviesViewModel Delegate Methods
extension MoviesMasterViewController: MoviesViewModelDelegate {
    func moviesLoadedSuccessfully() {
        tableView.reloadData()
    }
    
    func moviesFailedWithError(errorMessage: String) {
        // TODO: Handle error message
    }
}
