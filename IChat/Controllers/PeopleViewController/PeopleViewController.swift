//
//  PeopleViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit
import Firebase

class PeopleViewController: UIViewController {
    
    // MARK: - Property
    private var listener: ListenerRegistration?
    
    private let activiteIndecator = UIActivityIndicatorView(hidenWhenStoped: true)
    
    private enum Section: Int, CaseIterable {
        case users
        
        func description(count: Int) -> String {
            "\(count) people nearby"
        }
    }
    
    private var collectionView: UICollectionView!
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, MUser>?
    
    private var users = [MUser]()
      
    
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupRightBarButtonItem()
        setupCollectionView()
        
        setupCollectionViewDataSource()
        setupActiviteIndecator()
        registrationListener()

    }
    
    deinit {
        listener!.remove()
    }
}

// MARK: - Private method
extension PeopleViewController {
    
    
    private func registrationListener() {
        listener = ListenerService.shared.addListener(users: users, completion: { [unowned self] result in
            switch result {
            case .success(let users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                print(error)
            }
        })
    }
}

// MARK: - Search Delegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadData(with: nil)
    }
}


// MARK: - OBJC method
extension PeopleViewController {
    
    @objc private func signOut() {
        activiteIndecator.startAnimating()
        AuthService.shered.SignOut { [unowned self] result in
            switch result {
            case .success:
                self.activiteIndecator.stopAnimating()
                SceneDelegate.shared.rootViewController.goToAuthViewController()
            case .failure(let error):
                self.activiteIndecator.stopAnimating()
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}












// MARK: - Private method setup all layer
extension PeopleViewController {
    
    private func setupSearchController() {
        let searcheController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searcheController
        navigationItem.hidesSearchBarWhenScrolling = false
        searcheController.hidesNavigationBarDuringPresentation = false
        searcheController.obscuresBackgroundDuringPresentation = false
        searcheController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        collectionView.register(HeaderSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSection.reuseId)
    }
    
    private func setupCollectionViewDataSource() {
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            switch section {
            case .users:
                let cell = self.configureCell(collectionView: collectionView, cellType: UserCell.self, with: itemIdentifier, for: indexPath)
                return cell
            }
        })
        
        collectionViewDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSection.reuseId, for: indexPath) as? HeaderSection else { fatalError() }
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            let items = self.collectionViewDataSource!.snapshot().numberOfItems(inSection: .users)
            headerSection.configure(textHeader: section.description(count: items), font: .systemFont(ofSize: 36, weight: .light), textColor: .label)
            return headerSection
        }
    }
    
    private func reloadData(with searchText: String?) {
        let filterItems = users.filter { user in
            user.contains(filter: searchText)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filterItems, toSection: .users)
        collectionViewDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, collectioEnvironment in
            guard let section = Section(rawValue: sectionIndex) else { fatalError() }
            switch section {
            case .users:
                return self.createUserSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func createUserSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 15, bottom: 0, trailing: 16)
        section.interGroupSpacing = spacing
        
        let headerSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let headerSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSectionSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerSection]
        
        return section
    }
    
    private func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut))
    }
    
    private func setupActiviteIndecator() {
        view.addSubview(activiteIndecator)
        activiteIndecator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activiteIndecator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activiteIndecator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activiteIndecator.heightAnchor.constraint(equalToConstant: 90),
            activiteIndecator.widthAnchor.constraint(equalToConstant: 90)
        ])
    }

}
