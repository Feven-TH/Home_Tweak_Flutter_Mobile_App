
import 'dart:async' as _i5;

import 'package:frontend/features/user/data/user_model.dart' as _i3;
import 'package:frontend/features/user/domain/user_repository_interface.dart'
    as _i2;
import 'package:frontend/features/user/domain/user_usecases/delete_user.dart'
    as _i11;
import 'package:frontend/features/user/domain/user_usecases/forgot_password.dart'
    as _i7;
import 'package:frontend/features/user/domain/user_usecases/getUserById.dart'
    as _i9;
import 'package:frontend/features/user/domain/user_usecases/login.dart' as _i6;
import 'package:frontend/features/user/domain/user_usecases/logout.dart'
    as _i12;
import 'package:frontend/features/user/domain/user_usecases/reset_password.dart'
    as _i8;
import 'package:frontend/features/user/domain/user_usecases/signup.dart' as _i4;
import 'package:frontend/features/user/domain/user_usecases/update_user.dart'
    as _i10;
import 'package:mockito/mockito.dart' as _i1;



class _FakeUserRepositoryInterface_0 extends _i1.SmartFake
    implements _i2.UserRepositoryInterface {
  _FakeUserRepositoryInterface_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserModel_1 extends _i1.SmartFake implements _i3.UserModel {
  _FakeUserModel_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SignUpUser].

class MockSignUpUser extends _i1.Mock implements _i4.SignUpUser {
  MockSignUpUser() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepositoryInterface get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepositoryInterface_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepositoryInterface);

  @override
  _i5.Future<_i3.UserModel> call(
    String? username,
    String? email,
    String? password,
    String? role,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [
            username,
            email,
            password,
            role,
          ],
        ),
        returnValue: _i5.Future<_i3.UserModel>.value(_FakeUserModel_1(
          this,
          Invocation.method(
            #call,
            [
              username,
              email,
              password,
              role,
            ],
          ),
        )),
      ) as _i5.Future<_i3.UserModel>);
}

/// A class which mocks [LoginUser].

class MockLoginUser extends _i1.Mock implements _i6.LoginUser {
  MockLoginUser() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepositoryInterface get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepositoryInterface_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepositoryInterface);

  @override
  _i5.Future<_i3.UserModel> call(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [
            email,
            password,
          ],
        ),
        returnValue: _i5.Future<_i3.UserModel>.value(_FakeUserModel_1(
          this,
          Invocation.method(
            #call,
            [
              email,
              password,
            ],
          ),
        )),
      ) as _i5.Future<_i3.UserModel>);
}

/// A class which mocks [ForgotPassword].

class MockForgotPassword extends _i1.Mock implements _i7.ForgotPassword {
  MockForgotPassword() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepositoryInterface get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepositoryInterface_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepositoryInterface);

  @override
  _i5.Future<void> call(String? email) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [email],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [ResetPassword].

class MockResetPassword extends _i1.Mock implements _i8.ResetPassword {
  MockResetPassword() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepositoryInterface get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepositoryInterface_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepositoryInterface);

  @override
  _i5.Future<void> call(
    String? email,
    String? resetCode,
    String? newPassword,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [
            email,
            resetCode,
            newPassword,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [GetUserById].

class MockGetUserById extends _i1.Mock implements _i9.GetUserById {
  MockGetUserById() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepositoryInterface get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepositoryInterface_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepositoryInterface);

  @override
  _i5.Future<_i3.UserModel> call(int? id) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [id],
        ),
        returnValue: _i5.Future<_i3.UserModel>.value(_FakeUserModel_1(
          this,
          Invocation.method(
            #call,
            [id],
          ),
        )),
      ) as _i5.Future<_i3.UserModel>);
}

/// A class which mocks [UpdateUser].

class MockUpdateUser extends _i1.Mock implements _i10.UpdateUser {
  MockUpdateUser() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepositoryInterface get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepositoryInterface_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepositoryInterface);

  @override
  _i5.Future<_i3.UserModel> call(
    int? id,
    _i3.UserModel? user,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [
            id,
            user,
          ],
        ),
        returnValue: _i5.Future<_i3.UserModel>.value(_FakeUserModel_1(
          this,
          Invocation.method(
            #call,
            [
              id,
              user,
            ],
          ),
        )),
      ) as _i5.Future<_i3.UserModel>);
}

/// A class which mocks [DeleteUser].

class MockDeleteUser extends _i1.Mock implements _i11.DeleteUser {
  MockDeleteUser() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepositoryInterface get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepositoryInterface_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepositoryInterface);

  @override
  _i5.Future<void> call(int? id) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [LogoutUser].

class MockLogoutUser extends _i1.Mock implements _i12.LogoutUser {
  MockLogoutUser() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepositoryInterface get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeUserRepositoryInterface_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.UserRepositoryInterface);

  @override
  _i5.Future<void> call(int? userId) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [userId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}
