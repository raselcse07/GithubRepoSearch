//
//  SceneDelegate.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        startFlow(from: windowScene)
    }
}

extension SceneDelegate {
    
    fileprivate func startFlow(from windowScene: UIWindowScene) {
        let repoSeachViewController = RepoSearchViewController.instantiate()
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: repoSeachViewController)
    }
}

