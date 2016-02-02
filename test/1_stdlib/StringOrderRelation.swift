// RUN: %target-run-simple-swift
// REQUIRES: executable_test

import StdlibUnittest

// Also import modules which are used by StdlibUnittest internally. This
// workaround is needed to link all required libraries in case we compile
// StdlibUnittest with -sil-serialize-all.
import SwiftPrivate
#if _runtime(_ObjC)
import ObjectiveC
#endif

var StringOrderRelationTestSuite = TestSuite("StringOrderRelation")

StringOrderRelationTestSuite.test("StringOrderRelation/ASCII/NullByte")
  .xfail(.LinuxAny(reason: "String comparison: ICU vs. Foundation"))
  .xfail(.FreeBSDAny(reason: "String comparison: ICU vs. Foundation"))
  .code {
  let baseString = "a"
  let nullbyteString = "a\0"
  expectTrue(baseString < nullbyteString)
  expectTrue(baseString <= nullbyteString)
  expectFalse(baseString > nullbyteString)
  expectFalse(baseString >= nullbyteString)
  expectFalse(baseString == nullbyteString)
  expectTrue(baseString != nullbyteString)
}

runAllTests()

