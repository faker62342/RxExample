//
//  GitController.swift
//  RxExample
//
//  Created by Mohamed Ali BELHADJ on 15/05/2019.
//  Copyright © 2019 Hassine Faker. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class GitController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    
    var viewModel = GitViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        viewModel.data
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { _, repository, cell in
                cell.textLabel?.text = repository.repoName
                //                cell.detailTextLabel?.text = repository.repoURL
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.data.asDriver()
            .map { "\($0.count) Repositories" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "Faker62342"
        searchBar.placeholder = "Enter GitHub ID, e.g., \"Faker62342\""
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
}
