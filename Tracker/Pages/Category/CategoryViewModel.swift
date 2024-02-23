//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by mihail on 22.02.2024.
//

import Foundation

typealias Binding<T> = (T) -> Void

protocol CategoryViewModelProtocol {
    var categories: [TrackerCategory] { get }
    var categoriesBinding: Binding<[TrackerCategory]>? { get set }
    var categorySelectedBinding: Binding<TrackerCategory>? { get set }
    func didSelected(at indexPath: IndexPath)
}

final class CategoryViewModel: CategoryViewModelProtocol {
    //MARK: - privates properties
    private lazy var categoryStore = TrackerCategoryStore(delegate: self)
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    var categoriesBinding: Binding<[TrackerCategory]>?
    var categorySelectedBinding: Binding<TrackerCategory>?
    
    init() {
        categories = getAllCategoriesFromStore()
    }
    
    private func getAllCategoriesFromStore() -> [TrackerCategory] {
        categoryStore.objects()
    }
    
    func didSelected(at indexPath: IndexPath) {
        categorySelectedBinding?(categories[indexPath.item])
    }
}

//MARK: StoreDelegate
extension CategoryViewModel: StoreDelegate {
    func didUpdate() {
        categories = getAllCategoriesFromStore()
    }
}
