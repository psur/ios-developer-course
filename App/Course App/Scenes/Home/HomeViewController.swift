//
//  HomeViewController.swift
//  Course App
//
//  Created by Peter Surovy on 15.05.2024.
//

import Combine
import os
import SwiftUI
import UIKit

final class HomeViewController: UIViewController {
    // MARK: - UI constants
    private enum UIConstant {
        static let cellSpacing: CGFloat = 8
        static let collectionViewPadding: CGFloat = 5
        static let sectionInset: CGFloat = 4
        static let sectionScale: CGFloat = 3
        static let headerHeight: CGFloat = 40
    }

    // MARK: IBOutlets
    // swiftlint:disable:next prohibited_interface_builder
    @IBOutlet private var categoriesCollectionView: UICollectionView!

    // MARK: DataSource
    typealias DataSource = UICollectionViewDiffableDataSource<SectionData, [Joke]>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionData, [Joke]>

    // MARK: Private variables
    private lazy var dataProvider = MockDataProvider()
    private lazy var dataSource = makeDataSource()
    private lazy var cancellables = Set<AnyCancellable>()
    private lazy var logger = Logger()
    private let eventSubject = PassthroughSubject<HomeViewEvent, Never>()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        title = "Categories"
    }
}

// MARK: - EventEmitting
extension HomeViewController: EventEmitting {
    var eventPublisher: AnyPublisher<HomeViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width - UIConstant.cellSpacing, height: collectionView.bounds.height / UIConstant.sectionScale)
    }
}

// MARK: - UI setup
private extension HomeViewController {
    func setup() {
        setupCollectionView()
        readData()
    }

    func setupCollectionView() {
        categoriesCollectionView.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )

        categoriesCollectionView.backgroundColor = .bg
        categoriesCollectionView.isPagingEnabled = true
        categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        categoriesCollectionView.showsVerticalScrollIndicator = false
        categoriesCollectionView.delegate = self
        setupCollectionViewLayout()
    }

    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = UIConstant.cellSpacing
        layout.minimumInteritemSpacing = UIConstant.cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstant.sectionInset, bottom: 0, right: UIConstant.sectionInset)
        layout.sectionHeadersPinToVisibleBounds = true
        layout.headerReferenceSize = CGSize(width: categoriesCollectionView.contentSize.width, height: UIConstant.headerHeight)
        categoriesCollectionView.setCollectionViewLayout(layout, animated: false)
    }
}

// MARK: - UICollectionViewDataSource
private extension HomeViewController {
    func readData() {
        dataProvider.$data.sink { [weak self] data in
            self?.applySnapshot(data: data, animatingDifferences: true)
        }
        .store(in: &cancellables)
    }

    func applySnapshot(data: [SectionData], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(data)
        data.forEach { section in
            snapshot.appendItems([section.jokes], toSection: section)
        }

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<HorizontalScrollingCollectionViewCell, [Joke]> { cell, _, item in
            cell.configure(item) { [weak self] item in
                self?.eventSubject.send(.itemTapped(item))
            }
        }

        let dataSource = DataSource(collectionView: categoriesCollectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let labelCell: UICollectionViewCell = collectionView.dequeueSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath
            )
            labelCell.contentConfiguration = UIHostingConfiguration {
                Text(section.title)
                    .textStyle(textType: .sectionTitle)
            }
            return labelCell
        }

        return dataSource
    }
}
