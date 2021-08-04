//
//  RepoSearchCell.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/08/01.
//

import UIKit


class RepoSearchCell: UITableViewCell {
    
    private let repoName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let repoFullName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
}

// MARK: - Configure
extension RepoSearchCell {
    
    fileprivate func setupLayout() {
        [repoName, repoFullName, countLabel].forEach { addSubview($0) }
        setupConstraint()
    }
    
    fileprivate func setupConstraint() {
        NSLayoutConstraint.activate([
            // repo name
            repoName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            repoName.bottomAnchor.constraint(equalTo: repoFullName.topAnchor, constant: -10),
            repoName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            repoName.trailingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: -26),
            
            // repo full name
            repoFullName.leadingAnchor.constraint(equalTo: repoName.leadingAnchor),
            repoFullName.trailingAnchor.constraint(equalTo: repoName.trailingAnchor),
            repoFullName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            // count label
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    func setup(with model: GithubItem) {
        repoName.text = model.name
        repoFullName.text = model.fullName
        countLabel.text = "⭐️ \(model.stargazersCount)"
    }
}
