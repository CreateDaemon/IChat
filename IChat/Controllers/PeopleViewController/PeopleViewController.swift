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
    private let currentUser: MUser
    
    private var listener: ListenerRegistration?
    
    private let activiteIndecator = UIActivityIndicatorView(hidenWhenStoped: true)
    
    private enum Section: Hashable {
        case users(count: Int)
    }
    
    private var collectionView: UICollectionView!
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, MUser>?
    
    private var users = [MUser]()
      
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
                collectionViewDataSource?.apply(snapshot(with: nil))
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
}

// MARK: - OBJC method
extension PeopleViewController {
    
    @objc private func signOut() {
        showAlertWithCancel(title: "Confirmation",
                            message: "Do you really want to sign out?",
                            titleOkButton: "Yes",
                            titleCancelButton: "Cancel") { [unowned self] result in
            if result {
                self.activiteIndecator.startAnimating()
                AuthService.shered.SignOut { result in
                    switch result {
                    case .success:
                        self.activiteIndecator.stopAnimating()
                        SceneDelegate.shared.rootViewController.goToAuthViewController()
                    case .failure(let error):
                        self.activiteIndecator.stopAnimating()
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}


// MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionViewDataSource?.apply(snapshot(with: searchText))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collectionViewDataSource?.apply(snapshot(with: nil))
    }
}


// MARK: - UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let receiver = collectionViewDataSource?.itemIdentifier(for: indexPath) else { return }
        FirebaseService.shered.chekcSenderHaveActiveChat(receiver: receiver) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let chat):
                guard let chat = chat else {
                    let profileVC = ProfileScreenViewController(sender: self.currentUser, receiver: receiver)
                    self.present(profileVC, animated: true)
                    return
                }
                
                let chatVC = ChatViewController(currentUser: self.currentUser, chat: chat)
                self.navigationController?.pushViewController(chatVC, animated: true)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
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
        collectionView.register(HeaderSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSection.reuseIdentifier)
        
        collectionView.delegate = self
    }
    
    private func setupCollectionViewDataSource() {
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = self.configureCell(collectionView: collectionView, cellType: UserCell.self, with: itemIdentifier, for: indexPath)
            
            return cell
        })
        
        collectionViewDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { fatalError() }
            guard let headerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSection.reuseIdentifier, for: indexPath) as? HeaderSection else { fatalError() }
            headerSection.configure(textHeader: "\(self.users.count) people nearby", font: .systemFont(ofSize: 36, weight: .light), textColor: .label)
            return headerSection
        }
    }
    
    private func snapshot(with searchText: String?) -> NSDiffableDataSourceSnapshot<Section, MUser> {
        let filterItems = users.filter { user in
            user.contains(filter: searchText)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MUser>()
        let section: Section = .users(count: users.count)
        snapshot.appendSections([section])
        snapshot.appendItems(filterItems, toSection: section)
        return snapshot
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, collectioEnvironment in
            
                return self.createUserSection()
            
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
