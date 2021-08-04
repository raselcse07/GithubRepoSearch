//
//  RepoSearchViewController.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import UIKit

class RepoSearchViewController: BaseTableViewController {
    
    lazy private(set) var searchController: SeachBarController = {
        let searchBar = SeachBarController()
        return searchBar
    }()
    
    lazy private(set) var searchDebounce: Debouncer<String> = {
        let debouncer = Debouncer<String>(0.5)
        return debouncer
    }()
    
    var viewModel: RepoSeachViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Configure UI
extension RepoSearchViewController {
    
    fileprivate func initialize() {
        configureTableView()
        setupNavigationBar()
        setupObserver()
        executeSearch()
    }
    
    fileprivate func configureTableView() {
        viewModel.delegate = self
        tableView.register(RepoSearchCell.self)
        tableView.keyboardDismissMode = .interactive
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = false
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = Const.navigationTitle
        navigationItem.searchController = searchController
    }
}

// MARK: - Search Execute
extension RepoSearchViewController {
    
    fileprivate func setupObserver() {
        _ = searchController
            .update { [weak self] text in
                guard let strongSelf = self else { return }
                strongSelf.searchDebounce.receive(text)
            }
    }
    
    fileprivate func executeSearch() {
        searchDebounce.on { [weak self] text in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.setSearchTerm(text)
            strongSelf.sendApiRequest()
        }
    }
    
    fileprivate func sendApiRequest() {
        guard !viewModel.isStackEmpty else {
            viewModel.resetStack(false)
            updateTableView()
            return
        }
        viewModel.fetchRepository()
    }
}

// MARK: - Helper
extension RepoSearchViewController {
    
    fileprivate func updateTableView() {
        DispatchQueue.runOnMain { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.finishLoading()
            strongSelf.tableView.reloadData()
        }
    }
    
    fileprivate func loadMore() {
        guard let searchTerm = viewModel.searchTerm else {
            return
        }
        viewModel.setLoading(true)
        searchDebounce.receive(searchTerm)
    }
}
// MARK: - TableView Data Source
extension RepoSearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: RepoSearchCell.self)
        let item = viewModel.itemAt(for: indexPath)
        cell.setup(with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !viewModel.isLoading && !viewModel.isStackEmpty {
            tableView.waiting(indexPath) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.loadMore()
            }
        } 
    }
}


// MARK: - ViewModel delegate
extension RepoSearchViewController: RepoSeachViewModelProtocol {
    
    func onFetchCompleted() {
        viewModel.setRateLimit(false)
        // reload table view
        updateTableView()
    }
    
    func onRateLimitError() {
        DispatchQueue.runOnGlobal(delay: .milliseconds(3000)) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.setRateLimit(true)
            strongSelf.loadMore()
        }
    }
    
}

// MARK: - Instantiate ViewController
extension RepoSearchViewController {
    
    static func instantiate() -> RepoSearchViewController {
        let viewController = RepoSearchViewController()
        let viewModel = RepoSeachViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
}
