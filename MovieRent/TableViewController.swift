//
//  TableViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    var moviesData: MoviesData?
    var filterData = [Movies]()
    var action: [Movies] = []
    var comedy: [Movies] = []
    var drama: [Movies] = []
    var fantasy: [Movies] = []
    var crime: [Movies] = []
    typealias moviesString = LocalizedString.MoviesFilter
    typealias moviesTitle = LocalizedString.MoviesTitle
    @IBOutlet weak var searchBar: UISearchBar! { didSet {
        searchBar.resignFirstResponder() } }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterData = moviesData!.movies
        self.navigationItem.title = moviesTitle.movies
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerXib(xibName: MovieTableViewCell.className)
    }
    
    //MARK: - Set TableView & Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self)) as? MovieTableViewCell else { return UITableViewCell() }
        let filter = filterData[indexPath.item]
        cell.idLabel.text = filter.id
        cell.nameLabel.text = filter.name
        DispatchQueue.main.async { [self] in
            let category = filter.category
            addCategory(category: category, localizedS: moviesString.action.lowercased(), localizedC: moviesString.action.capitalized) { _ in
                if !self.action.contains(where: { $0 == filter}) {
                    self.action += [filter]
                }
            }
            addCategory(category: category, localizedS: moviesString.comedy.lowercased(), localizedC: moviesString.comedy.capitalized) { _ in
                if !self.comedy.contains(where: { $0 == filter}) {
                    self.comedy += [filter]
                }
            }
            addCategory(category: category, localizedS: moviesString.drama.lowercased(), localizedC: moviesString.drama.capitalized) { _ in
                if !self.drama.contains(where: { $0 == filter}) {
                    self.drama += [filter]
                }
            }
            addCategory(category: category, localizedS: moviesString.fantasy.lowercased(), localizedC: moviesString.fantasy.capitalized) { _ in
                if !self.fantasy.contains(where: { $0 == filter}) {
                    self.fantasy += [filter]
                }
            }
            addCategory(category: category, localizedS: moviesString.crime.lowercased(), localizedC: moviesString.crime.capitalized) { _ in
                if !self.crime.contains(where: { $0 == filter}) {
                    self.crime += [filter]
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlDeatilsId = "\(filterData[indexPath.row].id).txt"
        let urlDetailsString = "\(URLManager.shared.urlDetailsBase)\(urlDeatilsId)"
        guard let urlDetails = URL(string: "\(urlDetailsString)") else { return }
        RequestManager.shared.uploadFomURLDetails(url: urlDetails) { [weak self] jsonDetails in
            let detailsData = jsonDetails
            var urlImageString: String = "\(detailsData.imageURL)"
            if !urlImageString.contains("https") {
                urlImageString = urlImageString.replacingOccurrences(of: "http", with: "https")
            }
            guard let urlDetailImage = URL(string: "\(urlImageString)") else {return}
            //MARK: - Download PromoImage
            RequestManager.shared.downloadImage(url: urlDetailImage) { [weak self] (data, error) in
                DispatchQueue.main.async {
                    if let data = data {
                        let promoImage = UIImage(data: data)
                        self?.ShowDetails(detailsData: detailsData, promoImage: promoImage)
                    } else {
                        print(NetworkManagerError.badData)
                    }
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add Categoty
    func addCategory(category: String, localizedS: String, localizedC: String, complition: @escaping (Bool) -> (Void)) {
        if category == localizedS || category == localizedC {
            complition(true)
        }
    }
    
    //MARK: - Filter IBAction Collection
    @IBAction func allButton(_ sender: UIButton) {
        if let data = moviesData {
            filterData = data.movies
            self.navigationItem.title = moviesTitle.movies
        }
        self.tableView.reloadData()
    }
    @IBAction func actionButton(_ sender: UIButton) {
            filterData = action
        self.navigationItem.title = moviesTitle.action
            action = []
            self.tableView.reloadData()
    }
    @IBAction func comedyButton(_ sender: UIButton) {
        filterData = comedy
        self.navigationItem.title = moviesTitle.comedy
        comedy = []
        self.tableView.reloadData()
    }
    @IBAction func fantasyButton(_ sender: UIButton) {
        filterData = fantasy
        self.navigationItem.title = moviesTitle.fantasy
        fantasy = []
        self.tableView.reloadData()
    }
    @IBAction func crimeButton(_ sender: UIButton) {
        filterData = crime
        self.navigationItem.title = moviesTitle.crime
        crime = []
        self.tableView.reloadData()
    }
    @IBAction func dramaButton(_ sender: UIButton) {
        filterData = drama
        self.navigationItem.title = moviesTitle.drama
        drama = []
        self.tableView.reloadData()
    }
    
    
    //MARK: - Push to Details
    func ShowDetails(detailsData: DetailsData, promoImage: UIImage?) {
        DispatchQueue.main.async {
            let viewController = DetailsViewController.makeFromNib()
            viewController.detailsData = detailsData
            viewController.image = promoImage
            self.navigationController?.pushViewController(viewController, animated: true)
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
        if let data = moviesData {
            if searchBar.text == "" {
                filterData = data.movies
            }
            for word in data.movies {
                if word.name.contains(searchText) || word.category.contains(searchText) {
                    filterData.append(word)
                }
            }
        }
        self.tableView.reloadData()
    }
}
