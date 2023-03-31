//
//  TableViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    private var model: TableViewModel?
    typealias moviesString = LocalizedString.MoviesFilter
    typealias moviesTitle = LocalizedString.MoviesTitle
    @IBOutlet weak var searchBar: UISearchBar! { didSet {
        searchBar.resignFirstResponder() } }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = moviesTitle.movies
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerXib(xibName: MovieTableViewCell.className)
    }
    
    //MARK: - Set TableView & Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.model?.moviesResult.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self)) as? MovieTableViewCell else { return UITableViewCell() }
        if let movie = model?.moviesResult[indexPath.item] {
            cell.idLabel.text = movie.id
            cell.nameLabel.text = movie.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model?.selectRow(index: indexPath.row, completion: { [weak self] detailsData, promoImage in
            self?.showDetails(detailsData: detailsData, promoImage: promoImage)
        })
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func showDetails(detailsData: DetailsData, promoImage: UIImage?) {
       DispatchQueue.main.async {
           let viewController = DetailsViewController.makeFromNib()
           viewController.detailsData = detailsData
           viewController.image = promoImage
           self.navigationController?.pushViewController(viewController, animated: true)
       }
   }
    
    //MARK: - Filter IBAction Collection
    @IBAction func didTapFilter(_ sender: UIButton) {
        let category = MovieCategory(tag: sender.tag)
        model?.filterMovies(by: category) {
            self.searchBar.text = ""
            self.searchBar.endEditing(true)
            self.tableView.reloadData()
        }
    }
   
    //MARK: - Nib View
    static func makeFromNib(data: [Movie]) -> TableViewController {
        let nibName = TableViewController.className
        let vc = TableViewController(nibName: nibName, bundle: nil)
        vc.model = TableViewModel(allMovies: data)
        return vc
    }
}

//MARK: - SearchBar Method
extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model?.searchMovies(searchText: searchText, completion: {
            self.tableView.reloadData()
        })
    }
}
