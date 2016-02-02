// RUN: %target-swift-frontend -emit-ir -g %s -o - | FileCheck %s

public protocol OS_dispatch_queue {
}
public typealias dispatch_queue_t = OS_dispatch_queue

func dispatch_queue_create() -> dispatch_queue_t! {
  return nil
}

// CHECK: !DICompositeType(tag: DW_TAG_union_type,
// CHECK-SAME:             identifier: "_TtGSQa4main16dispatch_queue_t_"
// CHECK: !DIGlobalVariable(name: "queue",
// CHECK-SAME: line: [[@LINE+1]], type: !"_TtGSQa4main16dispatch_queue_t_"
public var queue = dispatch_queue_create()
