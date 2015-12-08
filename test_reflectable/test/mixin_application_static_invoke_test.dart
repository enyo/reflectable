// Copyright (c) 2015, the Dart Team. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in
// the LICENSE file.

library test_reflectable.test.mixin_application_static_invoke_test;

import "package:reflectable/reflectable.dart";
import "package:unittest/unittest.dart";

class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, declarationsCapability, libraryCapability,
            typeRelationsCapability);
}

@Reflector()
class M {
  static staticFoo(x) => x + 1;
}

@Reflector()
class A {
  static staticFoo(x) => x + 2;
}

@Reflector()
class B extends A with M {
  static staticFoo(x) => x + 3;
}

Matcher throwsANoSuchCapabilityException =
    throwsA(const isInstanceOf<NoSuchCapabilityError>());

main() {
  test("Mixin-application invoke", () {
    TypeMirror typeMirror = const Reflector().reflectType(B);
    expect(typeMirror is ClassMirror, true);
    ClassMirror classMirror = typeMirror;
    expect(() => classMirror.superclass.invoke("staticFoo", [10]),
        throwsANoSuchCapabilityException);
  });
  test("Mixin-application static member", () {
    TypeMirror typeMirror = const Reflector().reflectType(B);
    expect(typeMirror is ClassMirror, true);
    ClassMirror classMirror = typeMirror;
    expect(classMirror.superclass.declarations["staticFoo"], null);
  });
}
