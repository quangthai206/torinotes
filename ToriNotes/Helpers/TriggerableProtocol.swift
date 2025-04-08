//
//  TriggerableProtocol.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

protocol TriggerableProtocol: AnyObject {}

extension TriggerableProtocol {
  /// Call this to skip making handlers
  ///
  /// Before:
  ///
  /// ```
  /// func handleSomeEvent() -> VoidResult  {
  ///   return { [weak self] in
  ///     guard let self else { return }
  ///     self.someMethod()
  ///   }
  /// }
  ///
  /// self.onSomeEvent = handleSomeEvent()
  /// ```
  ///
  /// now becomes...
  ///
  /// ```
  /// self.onSomeEvent = trigger(type(of: self).someMethod)
  /// ```
  ///
  func trigger(_ callback: @escaping (Self) -> VoidResult) -> VoidResult {
    { [weak self] in
      guard let self else { return }
      return callback(self)()
    }
  }

  /// Call this to skip making handlers
  ///
  /// Before:
  ///
  /// ```
  /// func handleSomeEvent() -> SingleResult<[Model]>  {
  ///   return { [weak self] models in
  ///     guard let self else { return }
  ///     self.someMethod(models)
  ///   }
  /// }
  ///
  /// self.onSomeEvent = handleSomeEvent()
  /// ```
  ///
  /// now becomes...
  ///
  /// ```
  /// self.onSomeEvent = trigger(type(of: self).someMethod)
  /// ```
  ///
  func trigger<T>(_ callback: @escaping (Self) -> SingleResult<T>) -> SingleResult<T> {
    { [weak self] result in
      guard let self else { return }
      return callback(self)(result)
    }
  }

  /// Call this to skip making handlers
  ///
  /// Before:
  ///
  /// ```
  /// func handleSomeEvent() -> DoubleResult<T1, T2>  {
  ///   return { [weak self] result1, result2 in
  ///     guard let self else { return }
  ///     self.someMethod(result1, result2)
  ///   }
  /// }
  ///
  /// self.onSomeEvent = handleSomeEvent()
  /// ```
  ///
  /// now becomes...
  ///
  /// ```
  /// self.onSomeEvent = trigger(type(of: self).someMethod)
  /// ```
  ///
  func trigger<T1, T2>(_ callback: @escaping (Self) -> DoubleResult<T1, T2>) -> DoubleResult<T1, T2> {
    { [weak self] result1, result2 in
      guard let self else { return }
      return callback(self)(result1, result2)
    }
  }

  /// Call this to skip making handlers
  ///
  /// Before:
  ///
  /// ```
  /// func handleSomeEvent() -> VoidResult  {
  ///   return { [weak self] in
  ///     guard let self else { return }
  ///     self.onCallback?()
  ///   }
  /// }
  ///
  /// self.onSomeEvent = handleSomeEvent()
  /// ```
  ///
  /// now becomes...
  ///
  /// ```
  /// self.onSomeEvent = trigger(\.onCallback)
  /// ```
  ///
  func trigger(_ keypath: KeyPath<Self, VoidResult?>) -> VoidResult {
    { [weak self] in
      guard let self else { return }
      let callback = self[keyPath: keypath]
      callback?()
    }
  }

  /// Call this to skip making handlers
  ///
  /// Before:
  ///
  /// ```
  /// func handleSomeEvent() -> VoidResult  {
  ///   return { [weak self] result in
  ///     guard let self else { return }
  ///     self.onCallback?(result)
  ///   }
  /// }
  ///
  /// self.onSomeEvent = handleSomeEvent()
  /// ```
  ///
  /// now becomes...
  ///
  /// ```
  /// self.onSomeEvent = trigger(\.onCallback)
  /// ```
  ///
  func trigger<T>(_ keypath: KeyPath<Self, SingleResult<T>?>) -> SingleResult<T> {
    { [weak self] result in
      guard let self else { return }
      let callback = self[keyPath: keypath]
      callback?(result)
    }
  }

  /// Call this to skip making handlers
  ///
  /// Before:
  ///
  /// ```
  /// func handleSomeEvent(someObject: Value) -> VoidResult  {
  ///   return { [weak self, weak someObject] in
  ///     guard
  ///       let self,
  ///       let someObject = someObject
  ///     else { return }
  ///
  ///     self.someMethod?(someObject)
  ///   }
  /// }
  ///
  /// self.onSomeEvent = handleSomeEvent(someObject: someObject)
  /// ```
  ///
  /// now becomes...
  ///
  /// ```
  /// self.onSomeEvent = trigger(
  ///   type(of: self).someMethod,
  ///   passingValue: someObject
  ///  )
  /// ```
  ///
  func trigger<T: AnyObject>(
    _ callback: @escaping (Self) -> SingleResult<T>,
    passingValue value: T
  ) -> VoidResult {
    { [weak self, weak value] in
      guard
        let self,
        let value
      else { return }

      return callback(self)(value)
    }
  }

  /// Call this to skip making handlers
  ///
  /// Before:
  ///
  /// ```
  /// func handleSomeEvent(someValue: Value) -> VoidResult  {
  ///   return { [weak self] in
  ///     guard let self else { return }
  ///
  ///     self.someMethod?(someValue)
  ///   }
  /// }
  ///
  /// self.onSomeEvent = handleSomeEvent(someValue: someValue)
  /// ```
  ///
  /// now becomes...
  ///
  /// ```
  /// self.onSomeEvent = trigger(
  ///   type(of: self).someMethod,
  ///   passingValue: someValue
  ///  )
  /// ```
  ///
  func trigger<T>(
    _ callback: @escaping (Self) -> SingleResult<T>,
    passingValue value: T
  ) -> VoidResult {
    { [weak self, value] in
      guard let self else { return }

      return callback(self)(value)
    }
  }
}

extension NSObject: TriggerableProtocol {}
