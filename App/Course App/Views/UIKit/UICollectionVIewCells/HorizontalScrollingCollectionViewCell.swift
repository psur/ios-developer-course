//
//  HorizontalScrollingCollectionViewCell.swift
//  Course App
//
//  Created by Peter Surovy on 19.05.2024.
//


import os
import UIKit

final class HorizontalScrollingCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
    // MARK: UI constants
    private enum UIConstant {
        static let cellSpacing: CGFloat = 8
        static let collectionViewPadding: CGFloat = 5
        static let sectionInset: CGFloat = 4
    }

    // MARK: Data
    private var data: [Joke] = []

    // MARK: UI items
    private lazy var horizontalCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private lazy var logger = Logger()

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension HorizontalScrollingCollectionViewCell {
    func setData(_ data: [Joke]) {
        self.data = data
        horizontalCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension HorizontalScrollingCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        logger.info("Horizontal scrolling did select item \(indexPath)")
    }
}

// MARK: - UICollectionViewDataSource
extension HorizontalScrollingCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.imageView.image = data[indexPath.row].image
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HorizontalScrollingCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width - UIConstant.cellSpacing, height: collectionView.bounds.height)
    }
}

// MARK: - Setup UI
private extension HorizontalScrollingCollectionViewCell {
    func setupUI() {
        addSubviews()
        setupCollectionView()
        setupConstraints()
    }

    func addSubviews() {
        addSubview(horizontalCollectionView)
    }

    func setupCollectionView() {
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalCollectionView.showsHorizontalScrollIndicator = false
        horizontalCollectionView.isPagingEnabled = true
        horizontalCollectionView.backgroundColor = .bg

        setupCollectionViewLayout()
    }

    func setupCollectionViewLayout() {
        horizontalCollectionView.register(ImageCollectionViewCell.self)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = UIConstant.cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstant.sectionInset, bottom: 0, right: UIConstant.sectionInset)
        horizontalCollectionView.setCollectionViewLayout(layout, animated: false)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            horizontalCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstant.collectionViewPadding),
            horizontalCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: UIConstant.collectionViewPadding),
            horizontalCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIConstant.collectionViewPadding),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstant.collectionViewPadding)
        ])
    }
}
