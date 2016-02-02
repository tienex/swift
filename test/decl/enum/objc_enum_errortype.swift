// RUN: %target-parse-verify-swift

// REQUIRES: objc_interop

import Foundation

func acceptBridgeableNSError<E : _ObjectiveCBridgeableErrorType>(e: E) { }

@objc enum E1 : Int, ErrorType, _BridgedNSError {
  case A = 1
}

acceptBridgeableNSError(E1.A)

@objc enum E2 : Int, ErrorType {
  case A = 1
}

acceptBridgeableNSError(E2.A)


@objc enum E3 : Int {
  case A = 1
}

acceptBridgeableNSError(E3.A)
// expected-error@-1{{argument type 'E3' does not conform to expected type '_ObjectiveCBridgeableErrorType'}}
