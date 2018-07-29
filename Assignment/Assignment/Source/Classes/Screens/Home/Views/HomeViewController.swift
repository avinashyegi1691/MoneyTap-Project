//
//  ViewController.swift
//  Assignment
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 xyz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var viewModel = HomeViewModel()
    var viewState = ViewState.normal {
        didSet {
            switch viewState {
            case .normal:
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.listView.isHidden = true
                    weakSelf.errorLabel.isHidden = true
                    weakSelf.activityIndicator.stopAnimating()
                    weakSelf.activityIndicator.isHidden = true
                }
                
            case .loading:
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.listView.isHidden = true
                    weakSelf.errorLabel.isHidden = true
                    weakSelf.activityIndicator.startAnimating()
                    weakSelf.activityIndicator.isHidden = false
                }
                
            case .loaded:
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.listView.isHidden = false
                    weakSelf.listView.reloadData()
                    weakSelf.errorLabel.isHidden = true
                    weakSelf.activityIndicator.stopAnimating()
                    weakSelf.activityIndicator.isHidden = true
                }
                
            case .error(let message):
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else {return}
                    
                    weakSelf.listView.isHidden = true
                    weakSelf.errorLabel.isHidden = false
                    weakSelf.errorLabel.text = message
                    weakSelf.activityIndicator.stopAnimating()
                    weakSelf.activityIndicator.isHidden = true
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    //Setup
    func setUp(){
        self.title = viewModel.screenTitle
        self.searchBar.delegate  = self
        self.listView.delegate   = self
        self.listView.dataSource = self
        self.viewState = .normal
    }
}

//MARK:- SearchBar delegate methods
extension HomeViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder()

        if let searchText = searchBar.text {
            if searchText.count > 0 {
                self.viewState = .loading
                self.viewModel.getResults(for: searchText, completion: { (result) in
                    switch result {
                        case .success:
                            self.viewState = .loaded
                            break
                        case .failure(let message):
                            self.viewState = .error(message)
                            break
                    }
                })
            }else {
                self.viewState = .normal
            }
        }
    }
}

//MARK:- Tableview delegate datasource methods
extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ResultCell") as! ResultCell
        
        let resultViewModel = viewModel.viewModel(index: indexPath.row)
        cell.updateUI(viewModel: resultViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultViewModel = viewModel.viewModel(index: indexPath.row)

         let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let detailController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController{
                let viewModel = DetailViewModel(viewModel: resultViewModel)
                detailController.viewModel = viewModel
                self.navigationController?.pushViewController(detailController, animated: true)
            }
        }
}
