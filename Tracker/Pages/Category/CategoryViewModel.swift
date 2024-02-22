//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by mihail on 22.02.2024.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    //MARK: - piblic properties
    weak var delegate: CategoriesListViewControllerDelegate?
    
    //MARK: - privates properties
    private lazy var categoryStore = TrackerCategoryStore(delegate: self)
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    var categoriesBinding: Binding<[TrackerCategory]>?
    
    init(delegate: CategoriesListViewControllerDelegate) {
        self.delegate = delegate
        categories = getAllCategoriesFromStore()
    }
    
    private func getAllCategoriesFromStore() -> [TrackerCategory] {
        categoryStore.objects()
    }
    
    func didSelected(at indexPath: IndexPath) {
        delegate?.selectedCategory(categories[indexPath.item])
    }
}

//MARK: StoreDelegate
extension CategoryViewModel: StoreDelegate {
    func didUpdate() {
        categories = getAllCategoriesFromStore()
    }
}
