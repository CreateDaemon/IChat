//
//  ListViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit

enum Section: Int, CaseIterable {
    case waitingChats, activeChats
    
    func chootheNameHeader() -> String {
        switch self {
        case .waitingChats:
            return "Waiting chats"
        case .activeChats:
            return "Active chats"
        }
    }
}

struct MChat: Hashable, Decodable {
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.id == rhs.id
    }
}


class ListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    
    private let activeChatsData = Bundle.main.decode([MChat].self, from: "activeChats.json")!
    private let waitingChatsData = Bundle.main.decode([MChat].self, from: "waitingChats.json")!
    
    // MARK: - viewDidLaod()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchController()
        
        setupCollectionDataSource()
        reloadData()
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
        collectionView.register(HeaderSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSection.reuseId)
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(waitingChatsData, toSection: .waitingChats)
        snapshot.appendItems(activeChatsData, toSection: .activeChats)
        collectionViewDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupCollectionDataSource() {
        collectionViewDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            
            switch section {
            case .activeChats:
                let cell = self.configureCell(cellType: ActiveChatsCell.self, with: itemIdentifier, for: indexPath)
                return cell
            case .waitingChats:
                let cell = self.configureCell(cellType: WaitingChatsCell.self, with: itemIdentifier, for: indexPath)
                return cell
            }
        })
        
        collectionViewDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSection.reuseId, for: indexPath) as? HeaderSection else { fatalError() }
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            headerSection.configure(textHeader: section.chootheNameHeader(), font: .laoSangamMN20(), textColor: .lightGray)
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
    
    private func configureCell<T: SelfConfiguringCell>(cellType: T.Type, with value: MChat, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError() }
        cell.updateCell(data: value)
        return cell
    }
}


// MARK: - Search Delegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}





// MARK: - PreviewProvider

import SwiftUI

struct ListVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
