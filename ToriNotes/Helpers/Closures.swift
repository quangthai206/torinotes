//
//  Closures.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

// MARK: - Typealias > Base

typealias EmptyResult<ReturnType> = () -> ReturnType
typealias SingleResultWithReturn<T, ReturnType> = (T) -> ReturnType
typealias DoubleResultWithReturn<T1, T2, ReturnType> = (T1, T2) -> ReturnType


// MARK: - Typealias > Void Return

typealias SingleResult<T> = SingleResultWithReturn<T, Void>
typealias DoubleResult<T1, T2> = DoubleResultWithReturn<T1, T2, Void>

// MARK: Typealias > Most Used

// () -> Void
typealias VoidResult = EmptyResult<Void>
// (Error) -> Void
typealias ErrorResult = SingleResult<Error>
// (Bool) -> Void
typealias BoolResult = SingleResult<Bool>

// MARK: - Default Closure Values

enum DefaultClosure {
  static func voidResult() -> VoidResult { {} }
  static func singleResult<T>() -> SingleResult<T> { { _ in } }
  static func doubleResult<T1, T2>() -> DoubleResult<T1, T2> { { _, _ in } }
}
