//
//  MasterViewController.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit
import RevealingSplashView

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
        
        setupAnimatedSplashScreen()
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
    private func setupAnimatedSplashScreen() {
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "movies-icon-white"), iconInitialSize: CGSize(width: 125, height: 125), backgroundColor: UIColor.defaultAppThemeColor)
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.addSubview(revealingSplashView)
        revealingSplashView.startAnimation()
    }
    
    private func setupUI() {
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MovieDetailViewController
        }
        
        tableView.tableFooterView = UIView()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        searchBar.set(textColor: .white)
        searchBar.setTextField(color: UIColor.defaultAppThemeColor)
        searchBar.setPlaceholder(textColor: UIColor.white.withAlphaComponent(0.3))
        searchBar.setSearchImage(color: .white)
        searchBar.searchTextField.clearButtonMode = .never
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
                let controller = (segue.destination as! UINavigationController).topViewController as! MovieDetailViewController
                if let movie = moviesViewModel.movie(at: indexPath.row, yearIndex: indexPath.section) {
                    controller.movie = movie
                }
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }
}


// MARK: - Table View
extension MoviesMasterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return moviesViewModel.numberOfMoviesSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesViewModel.numberOfMovies(yearIndex: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = moviesViewModel.title(at: indexPath.row, yearIndex: indexPath.section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return moviesViewModel.yearTitle(at: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
            headerView.backgroundView?.backgroundColor = .black
            headerView.textLabel?.textColor = .defaultAppThemeColor
            headerView.textLabel?.font = UIFont.appFont(withSize: 14.0, andWeight: .regular)
        }
    }
}


// MARK: - UISearchBar Delegate Methods
extension MoviesMasterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchKeyword: String? = searchText
        if searchText.isEmpty {
            searchKeyword = nil
        }
        moviesViewModel.searchMovies(keyword: searchKeyword)
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
    
    func movieImagesLoadedSuccessfully() {
        // Do nothing
    }
    
    func movieImagesFailedWithError(errorMessage: String) {
        // Do nothing
    }
}
