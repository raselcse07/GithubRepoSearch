//
//  RepoSeachViewModel.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/08/01.
//

import Foundation

protocol RepoSeachViewModelProtocol: AnyObject {
    func onFetchCompleted()
    func onRateLimitError()
}

final class RepoSeachViewModel {
    
    // MARK: - Properties
    var repositories: [GithubItem] = []
    
    var searchTerm: String? {
        didSet {
            release()
        }
    }
    
    private(set) var isFetchInProgress: Bool = false
    private(set) var isLoading: Bool = false
    private(set) var isStackEmpty: Bool = false
    private(set) var isRateLimitExceed: Bool = false
    private(set) var currentPage: Int = Const.initialPage
    
    weak var delegate: RepoSeachViewModelProtocol?
    
    func numberOfRowsInSection() -> Int {
        return repositories.count
    }
    
    func itemAt(for indexPath: IndexPath) -> GithubItem {
        return repositories[indexPath.row]
    }
    
    func setSearchTerm(_ text: String) {
        if !isLoading {
            searchTerm = text
        }
    }
    
    func setRateLimit(_ isExists: Bool) {
        isRateLimitExceed = isExists
    }
    
    func setLoading(_ loading: Bool) {
        isLoading = loading
    }
    
    func resetStack(_ isEmpty: Bool) {
        isStackEmpty = isEmpty
    }
    
    // MARK: - API Request
    func fetchRepository() {
    
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        // check the search string
        if searchTerm == .empty || searchTerm == nil {
            release()
            finishProccess()
            delegate?.onFetchCompleted()
        } else {
            let request = GithubRepoRequest(searchString: searchTerm!, page: getPage())
            APIClient.default.send(request) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                    case .success(let model):
                        strongSelf.onSuccess(model.body)
                    case .failure(let error):
                        strongSelf.onError(APIError.convert(from: error))
                }
            }
        }
    }
    
    // MARK: - Private Method
    private func add(_ model: GithubModel) {
        repositories.append(contentsOf: model.items)
    }
    
    private func release() {
        repositories.removeAll()
    }
    
    private func setStack(_ ammount: Int) {
        isStackEmpty = (ammount == 0)
    }
    
    private func getPage() -> Int {
        var page: Int = 0
        if isLoading && !isStackEmpty {
            if isRateLimitExceed {
                page = currentPage
            } else {
                currentPage += Const.initialPage
                page = currentPage
            }
        } else {
            page = Const.initialPage
        }
        return page
    }
    
    private func onSuccess(_ model: GithubModel) {
        finishProccess()
        setStack(model.items.count)
        add(model)
        delegate?.onFetchCompleted()
    }
    
    private func onError(_ error: APIError) {

        if !isLoading {
            finishProccess()
            delegate?.onFetchCompleted()
        } else {
            finishProccess()
            if error == APIError.E1003 {
                delegate?.onRateLimitError()
            } else {
                delegate?.onFetchCompleted()
            }
        }
    }
    
    private func finishProccess() {
        if isLoading {
            isLoading = false
        }
        if isFetchInProgress {
            isFetchInProgress = false
        }
    }
}
