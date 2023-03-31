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
    let model = TableViewModel()
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
//        model.setTableView(data: filterData, index: indexPath, action: action.self, comedy: comedy.self, drama: drama.self, fantasy: fantasy.self, crime: crime.self) { [weak self] (addAction, addComedy, addDrama, addFantasy, addCrime) in
//
//                #warning("What happend here!!!!???")
//                guard let addAction = addAction else {return}
//                self?.action += addAction
//                guard let addComedy = addComedy else {return}
//                self?.comedy += addComedy
//                guard let addDrama = addDrama else {return}
//                self?.drama += addDrama
//                guard let addFantasy = addFantasy else {return}
//                self?.fantasy += addFantasy
//                guard let addCrime = addCrime else {return}
//                self?.crime += addCrime
//
//        }
            
            
        
        
        
        
//        let filter = filterData[indexPath.item]
//        cell.idLabel.text = filter.id
//        cell.nameLabel.text = filter.name
        DispatchQueue.main.async { [self] in
            let category = filter.category
            model.addCategory(category: category, localizedS: moviesString.action, localizedC: moviesString.action.capitalized, myCategory: action, filter: filter) { _ in
                self.action += [filter]
            }
            model.addCategory(category: category, localizedS: moviesString.comedy, localizedC: moviesString.comedy.capitalized, myCategory: comedy, filter: filter) { _ in
                self.comedy += [filter]
            }
            model.addCategory(category: category, localizedS: moviesString.drama, localizedC: moviesString.drama.capitalized, myCategory: drama, filter: filter) { _ in
                self.drama += [filter]
            }
            model.addCategory(category: category, localizedS: moviesString.fantasy, localizedC: moviesString.fantasy.capitalized, myCategory: fantasy, filter: filter) { _ in
                self.fantasy += [filter]
            }
            model.addCategory(category: category, localizedS: moviesString.crime, localizedC: moviesString.crime.capitalized, myCategory: crime, filter: filter) { _ in
                self.crime += [filter]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selectRow(data: filterData, index: indexPath, navigation: self.navigationController)
        tableView.deselectRow(at: indexPath, animated: true)
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
            model.searchBarSet(data: data, bar: searchBar, searchText: searchText) { [weak self] (fullData, word) in
                if let fullData = fullData {
                    self?.filterData = fullData
                }
                if let word = word {
                    self?.filterData.append(word)
                }
            }
        }
        self.tableView.reloadData()
    }
}
