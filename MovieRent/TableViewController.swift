//
//  TableViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Properties
    var moviesData = MoviesData(movies: [Movies(id: String(), name: String(), year: String(), category: String())])
    var filterData = [Movies]()
    @IBOutlet weak var searchBar: UISearchBar! { didSet {
        searchBar.resignFirstResponder() } }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movies"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: "MovieTableViewCell")
    }

    //MARK: - Set TableView & cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self)) as? MovieTableViewCell //else { return UITableViewCell() }
        cell?.idLabel.text = self.filterData[indexPath.row].id
        cell?.nameLabel.text = self.filterData[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlDeatilsId = "\(filterData[indexPath.row].id).txt"
        let urlDetailsString = "\(URLManager.shared.urlDetailsBase)\(urlDeatilsId)"
        guard let urlDetails = URL(string: "\(urlDetailsString)") else { return }
        RequestManager.shared.uploadFomURLDetails(url: urlDetails) { jsonDetails in
            let detailsData = jsonDetails
            self.ShowDetails(detailsData: detailsData)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Push to Details
    func ShowDetails(detailsData: DetailsData) {
        DispatchQueue.main.async {
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let firstWindow = firstScene.windows.first else { return }
            let viewController = DetailsViewController.makeFromNib()
            if let nav = firstWindow.rootViewController as? UINavigationController {
                viewController.detailsData = detailsData
                nav.pushViewController(viewController, animated: true)
            }
        }
    }
    //MARK: - Nib View
    static func makeFromNib() -> TableViewController {
        let nibName = TableViewController.className
        let vc = TableViewController(nibName: nibName, bundle: nil)
        return vc
    }
}

//MARK: - SearchBar Method
extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []
        if searchBar.text == "" {
            filterData = moviesData.movies
        }
        for word in moviesData.movies {
            if word.name.contains(searchText) {
                filterData.append(word)
            }
        }
        self.tableView.reloadData()
    }
}
