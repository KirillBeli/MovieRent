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
            addCategory(category: category, localizedS: moviesString.action, localizedC: moviesString.action.capitalized, myCategory: action, filter: filter) { _ in
                self.action += [filter]
            }
            addCategory(category: category, localizedS: moviesString.comedy, localizedC: moviesString.comedy.capitalized, myCategory: comedy, filter: filter) { _ in
                self.comedy += [filter]
            }
            addCategory(category: category, localizedS: moviesString.drama, localizedC: moviesString.drama.capitalized, myCategory: drama, filter: filter) { _ in
                self.drama += [filter]
            }
            addCategory(category: category, localizedS: moviesString.fantasy, localizedC: moviesString.fantasy.capitalized, myCategory: fantasy, filter: filter) { _ in
                self.fantasy += [filter]
            }
            addCategory(category: category, localizedS: moviesString.crime, localizedC: moviesString.crime.capitalized, myCategory: crime, filter: filter) { _ in
                self.crime += [filter]
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
                        print(NetworkManagerError.errorData)
                    }
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add Categoty
    func addCategory(category: String, localizedS: String, localizedC: String, myCategory: [Movies], filter: Movies, completion: @escaping (Bool) -> ()) {
        if category == localizedS || category == localizedC {
            if !myCategory.contains(where: { $0 == filter}) {
                completion(true)
            }
        }
    }
    
    //MARK: - Filter IBAction Collection
    func filterByButton(EqualTo: [Movies], title: String, completion: @escaping ()->()) {
        self.filterData = EqualTo
        self.navigationItem.title = title
        completion()
        self.tableView.reloadData()
    }
    
    @IBAction func allButton(_ sender: UIButton) {
        if let data = moviesData {
            filterData = data.movies
            self.navigationItem.title = moviesTitle.movies
            self.tableView.reloadData()
        }
    }
    @IBAction func actionButton(_ sender: UIButton) {
        filterByButton(EqualTo: action, title: moviesTitle.action) {
            self.action = []
        }
    }
    @IBAction func comedyButton(_ sender: UIButton) {
        filterByButton(EqualTo: comedy, title: moviesTitle.comedy) {
            self.comedy = []
        }
    }
    @IBAction func fantasyButton(_ sender: UIButton) {
        filterByButton(EqualTo: fantasy, title: moviesTitle.fantasy) {
            self.fantasy = []
        }
    }
    @IBAction func crimeButton(_ sender: UIButton) {
        filterByButton(EqualTo: crime, title: moviesTitle.crime) {
            self.crime = []
        }
    }
    @IBAction func dramaButton(_ sender: UIButton) {
        filterByButton(EqualTo: drama, title: moviesTitle.drama) {
            self.drama = []
        }
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
