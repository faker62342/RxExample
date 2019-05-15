//
//  GitViewModel.swift
//  RxExample
//
//  Created by Mohamed Ali BELHADJ on 15/05/2019.
//  Copyright © 2019 Hassine Faker. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GitViewModel {
    let searchText = BehaviorRelay(value: "")
    
    lazy var data: Driver<[Repository]> = { //Bind searchText to the data Observable
        
        return self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(GitViewModel.repositoriesBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func repositoriesBy(_ githubID: String) -> Observable<[Repository]> { //Retrieve github repo of a specific user
        guard !githubID.isEmpty,
            let url = URL(string: "https://api.github.com/users/\(githubID)/repos") else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            //.catchErrorJustReturn([])
            .map(parse)
    }
    
    static func parse(json: Any) -> [Repository] { // Parsing the retieved json data to an array of repositories
        guard let items = json as? [[String: Any]]  else {
            return []
        }
        
        var repositories = [Repository]()
        
        items.forEach{
            guard let repoName = $0["name"] as? String,
                let repoURL = $0["html_url"] as? String else {
                    return
            }
            repositories.append(Repository(repoName: repoName, repoURL: repoURL))
        }
        return repositories
    }
}
