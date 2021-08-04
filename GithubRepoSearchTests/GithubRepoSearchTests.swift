//
//  GithubRepoSearchTests.swift
//  GithubRepoSearchTests
//
//  Created by Rasel on 2021/08/04.
//

import XCTest

@testable import GithubRepoSearch


class GithubRepoSearchTests: XCTestCase {
    
    var repoController: RepoSearchViewController {
        return RepoSearchViewController.instantiate()
    }
    
    var repo: [GithubItem] {
        return [
            GithubItem(name: "iOS", fullName: "ios/tableView", stargazersCount: 100),
            GithubItem(name: "UIKit", fullName: "ios/ui", stargazersCount: 300)
        ]
    }
    
    func test_hasOneSection() {
        let sectionCount = repoController.numberOfSections(in: repoController.tableView)
        XCTAssertEqual(sectionCount, 1)
    }
    
    func test_checkNumberOfRows() {
        repoController.viewModel.repositories = repo
        let rowCount = repoController.tableView(repoController.tableView, numberOfRowsInSection: 1)
        XCTAssertEqual(rowCount, repoController.viewModel.numberOfRowsInSection())
    }
    
    func test_removeExistingRepoForNewSearch() {
        _ = repoController.searchController
            .update { [weak self] _ in
                guard let strongSelf = self else { return }
                XCTAssertTrue(strongSelf.repoController.viewModel.repositories.isEmpty )
            }
    }

}
