// RUN: rm -rf %t && mkdir -p %t/before && mkdir -p %t/after

// RUN: %target-build-swift -emit-library -Xfrontend -enable-resilience -D BEFORE -c %S/Inputs/struct_fixed_layout_remove_conformance.swift -o %t/before/struct_fixed_layout_remove_conformance.o
// RUN: %target-build-swift -emit-module -Xfrontend -enable-resilience -D BEFORE -c %S/Inputs/struct_fixed_layout_remove_conformance.swift -o %t/before/struct_fixed_layout_remove_conformance.o

// RUN: %target-build-swift -emit-library -Xfrontend -enable-resilience -D AFTER -c %S/Inputs/struct_fixed_layout_remove_conformance.swift -o %t/after/struct_fixed_layout_remove_conformance.o
// RUN: %target-build-swift -emit-module -Xfrontend -enable-resilience -D AFTER -c %S/Inputs/struct_fixed_layout_remove_conformance.swift -o %t/after/struct_fixed_layout_remove_conformance.o

// RUN: %target-build-swift -D BEFORE -c %s -I %t/before -o %t/before/main.o
// RUN: %target-build-swift -D AFTER -c %s -I %t/after -o %t/after/main.o

// RUN: %target-build-swift %t/before/struct_fixed_layout_remove_conformance.o %t/before/main.o -o %t/before_before
// RUN: %target-build-swift %t/before/struct_fixed_layout_remove_conformance.o %t/after/main.o -o %t/before_after
// RUN: %target-build-swift %t/after/struct_fixed_layout_remove_conformance.o %t/before/main.o -o %t/after_before
// RUN: %target-build-swift %t/after/struct_fixed_layout_remove_conformance.o %t/after/main.o -o %t/after_after

// RUN: %target-run %t/before_before
// RUN: %target-run %t/before_after
// RUN: %target-run %t/after_before
// RUN: %target-run %t/after_after

import StdlibUnittest
import struct_fixed_layout_remove_conformance

var StructFixedLayoutRemoveConformanceTest = TestSuite("StructFixedLayoutRemoveConformance")

StructFixedLayoutRemoveConformanceTest.test("RemoveConformance") {
  var t = RemoveConformance()

  do {
    t.x = 10
    t.y = 20
    expectEqual(t.x, 10)
    expectEqual(t.y, 20)
  }
}

#if AFTER
protocol MyPointLike {
  var x: Int { get set }
  var y: Int { get set }
}

protocol MyPoint3DLike {
  var z: Int { get set }
}

extension RemoveConformance : MyPointLike {}
extension RemoveConformance : MyPoint3DLike {}

@inline(never) func workWithMyPointLike<T>(t: T) {
  var p = t as! MyPointLike
  p.x = 50
  p.y = 60
  expectEqual(p.x, 50)
  expectEqual(p.y, 60)
}

StructFixedLayoutRemoveConformanceTest.test("MyPointLike") {
  var p: MyPointLike = RemoveConformance()

  do {
    p.x = 50
    p.y = 60
    expectEqual(p.x, 50)
    expectEqual(p.y, 60)
  }

  workWithMyPointLike(p)
}
#endif

runAllTests()

