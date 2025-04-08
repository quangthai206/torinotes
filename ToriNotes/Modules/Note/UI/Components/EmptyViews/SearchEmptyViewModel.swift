//
//  SearchEmptyViewModel.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

class SearchEmptyViewModel: EmptyViewModelProtocol {}

// MARK: - Getters

extension SearchEmptyViewModel {
  var emptyIconName: String { "iconSearch" }
  var titleString: String { "No results" }
  var descriptionString: String { "Check spelling or try a new search." }
}
