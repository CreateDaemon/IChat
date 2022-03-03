//
//  ListViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit
import Firebase


class ListViewController: UIViewController {
    
    private enum Section: Int, CaseIterable {
        case waitingChats, activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }
    
    private var collectionView: UICollectionView!
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    
    private let currentUser: MUser
    
    private var activeChats = [MChat]()
    private var waitingChats = [MChat]()
    
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    // MARK: - viewDidLaod()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchController()
        
        setupCollectionDataSource()
        
        activeChatsListener = ListenerService.shared.addListenerActiveChats(activeChats: activeChats, completion: { [unowned self] result in
            switch result {
            case .success(let chats):
                self.activeChats = chats
                reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
        
        waitingChatsListener = ListenerService.shared.addListenerWaitingChats(waitingChats: waitingChats, completion: { [unowned self] result in
            switch result {
            case .success(let chats):
                if chats.count > self.waitingChats.count {
                    guard let user = chats.last else { return }
                    let chatRequestVC = ChatRequestViewController(currentChat: user)
                    chatRequestVC.config()
                    chatRequestVC.delegate = self
                    present(chatRequestVC, animated: true)
                }
                self.waitingChats = chats
                reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
        
        
    }
}


// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}


// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let section = Section(rawValue: indexPath.section),
            let chat = collectionViewDataSource?.itemIdentifier(for: indexPath)
        else {
            return }
        
        switch section {
        case .waitingChats:
            let chatRequestVC = ChatRequestViewController(currentChat: chat)
            chatRequestVC.config()
            chatRequestVC.delegate = self
            present(chatRequestVC, animated: true)
        case .activeChats:
            let chatVC = ChatViewController(currentUser: currentUser, chat: chat)
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}


// MARK: - UICollectionViewDelegate
extension ListViewController: ChatRequestDelegate {
    
    func acceptWaitingChat(sender: MChat) {
        FirebaseService.shered.createActiveChat(sender: sender) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.dismiss(animated: true) {
                    let chatVC = ChatViewController(currentUser: self.currentUser, chat: sender)
                    self.navigationController?.pushViewController(chatVC, animated: true)
                }
            case .failure(let error):
                self.dismiss(animated: true)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func denyWaitingChat(senderID: String) {
        FirebaseService.shered.deleteAllMessageInChat(senderID: senderID) { [unowned self] result in
            switch result {
            case .success:
                self.dismiss(animated: true)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}






















// MARK: - Private method
extension ListViewController {
    
    private func setupSearchController() {
        let searcheController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searcheController
        navigationItem.hidesSearchBarWhenScrolling = false
        searcheController.hidesNavigationBarDuringPresentation = false
        searcheController.obscuresBackgroundDuringPresentation = false
        searcheController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setupCollectionViewLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(ActiveChatsCell.self, forCellWithReuseIdentifier: ActiveChatsCell.reuseId)
        collectionView.register(WaitingChatsCell.self, forCellWithReuseIdentifier: WaitingChatsCell.reuseId)
        collectionView.register(HeaderSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSection.reuseIdentifier)
        
        collectionView.delegate = self
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(activeChats, toSection: .activeChats)
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        collectionViewDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupCollectionDataSource() {
        collectionViewDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            
            switch section {
            case .activeChats:
                let cell = self.configureCell(collectionView: collectionView, cellType: ActiveChatsCell.self, with: itemIdentifier, for: indexPath)
                return cell
            case .waitingChats:
                let cell = self.configureCell(collectionView: collectionView, cellType: WaitingChatsCell.self, with: itemIdentifier, for: indexPath)
                return cell
            }
        })
        
        collectionViewDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSection.reuseIdentifier, for: indexPath) as? HeaderSection else { fatalError() }
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            headerSection.configure(textHeader: section.description(), font: .laoSangamMN20(), textColor: .lightGray)
            return headerSection
        }
        
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { indexSection, collectionEnvironment in
            
            guard let section = Section(rawValue: indexSection) else { fatalError() }
            
            switch section {
            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWaitingChats()
            }
        })
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        collectionViewLayout.configuration = config
        
        return collectionViewLayout
    }
    
    private func createActiveChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        let headerSection = createHeaderSection()
        section.boundarySupplementaryItems = [headerSection]
        
        return section
    }
    
    private func createWaitingChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88),
                                               heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSection = createHeaderSection()
        section.boundarySupplementaryItems = [headerSection]
        
        return section
    }
    
    private func createHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        let hedearSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hedearSectionSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

