// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: universal_message.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.
//
// Adapted from https://github.com/teslamotors/vehicle-command

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

enum Domain: SwiftProtobuf.Enum {
  typealias RawValue = Int
  case broadcast // = 0
  case vehicleSecurity // = 2
  case infotainment // = 3
  case authd // = 5
  case energyDevice // = 7
  case energyDeviceAuth // = 8
  case UNRECOGNIZED(Int)

  init() {
    self = .broadcast
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .broadcast
    case 2: self = .vehicleSecurity
    case 3: self = .infotainment
    case 5: self = .authd
    case 7: self = .energyDevice
    case 8: self = .energyDeviceAuth
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .broadcast: return 0
    case .vehicleSecurity: return 2
    case .infotainment: return 3
    case .authd: return 5
    case .energyDevice: return 7
    case .energyDeviceAuth: return 8
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension Domain: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static let allCases: [Domain] = [
    .broadcast,
    .vehicleSecurity,
    .infotainment,
    .authd,
    .energyDevice,
    .energyDeviceAuth,
  ]
}

#endif  // swift(>=4.2)

enum MessageFault_E: SwiftProtobuf.Enum {
  typealias RawValue = Int
  case rrorNone // = 0
  case rrorBusy // = 1
  case rrorTimeout // = 2
  case rrorUnknownKeyID // = 3
  case rrorInactiveKey // = 4
  case rrorInvalidSignature // = 5
  case rrorInvalidTokenOrCounter // = 6
  case rrorInsufficientPrivileges // = 7
  case rrorInvalidDomains // = 8
  case rrorInvalidCommand // = 9
  case rrorDecoding // = 10
  case rrorInternal // = 11
  case rrorWrongPersonalization // = 12
  case rrorBadParameter // = 13
  case rrorKeychainIsFull // = 14
  case rrorIncorrectEpoch // = 15
  case rrorIvIncorrectLength // = 16
  case rrorTimeExpired // = 17
  case rrorNotProvisionedWithIdentity // = 18
  case rrorCouldNotHashMetadata // = 19
  case rrorTimeToLiveTooLong // = 20
  case rrorRemoteAccessDisabled // = 21
  case rrorRemoteServiceAccessDisabled // = 22
  case rrorCommandRequiresAccountCredentials // = 23
  case rrorRequestMtuExceeded // = 24
  case rrorResponseMtuExceeded // = 25
  case UNRECOGNIZED(Int)

  init() {
    self = .rrorNone
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .rrorNone
    case 1: self = .rrorBusy
    case 2: self = .rrorTimeout
    case 3: self = .rrorUnknownKeyID
    case 4: self = .rrorInactiveKey
    case 5: self = .rrorInvalidSignature
    case 6: self = .rrorInvalidTokenOrCounter
    case 7: self = .rrorInsufficientPrivileges
    case 8: self = .rrorInvalidDomains
    case 9: self = .rrorInvalidCommand
    case 10: self = .rrorDecoding
    case 11: self = .rrorInternal
    case 12: self = .rrorWrongPersonalization
    case 13: self = .rrorBadParameter
    case 14: self = .rrorKeychainIsFull
    case 15: self = .rrorIncorrectEpoch
    case 16: self = .rrorIvIncorrectLength
    case 17: self = .rrorTimeExpired
    case 18: self = .rrorNotProvisionedWithIdentity
    case 19: self = .rrorCouldNotHashMetadata
    case 20: self = .rrorTimeToLiveTooLong
    case 21: self = .rrorRemoteAccessDisabled
    case 22: self = .rrorRemoteServiceAccessDisabled
    case 23: self = .rrorCommandRequiresAccountCredentials
    case 24: self = .rrorRequestMtuExceeded
    case 25: self = .rrorResponseMtuExceeded
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .rrorNone: return 0
    case .rrorBusy: return 1
    case .rrorTimeout: return 2
    case .rrorUnknownKeyID: return 3
    case .rrorInactiveKey: return 4
    case .rrorInvalidSignature: return 5
    case .rrorInvalidTokenOrCounter: return 6
    case .rrorInsufficientPrivileges: return 7
    case .rrorInvalidDomains: return 8
    case .rrorInvalidCommand: return 9
    case .rrorDecoding: return 10
    case .rrorInternal: return 11
    case .rrorWrongPersonalization: return 12
    case .rrorBadParameter: return 13
    case .rrorKeychainIsFull: return 14
    case .rrorIncorrectEpoch: return 15
    case .rrorIvIncorrectLength: return 16
    case .rrorTimeExpired: return 17
    case .rrorNotProvisionedWithIdentity: return 18
    case .rrorCouldNotHashMetadata: return 19
    case .rrorTimeToLiveTooLong: return 20
    case .rrorRemoteAccessDisabled: return 21
    case .rrorRemoteServiceAccessDisabled: return 22
    case .rrorCommandRequiresAccountCredentials: return 23
    case .rrorRequestMtuExceeded: return 24
    case .rrorResponseMtuExceeded: return 25
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension MessageFault_E: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static let allCases: [MessageFault_E] = [
    .rrorNone,
    .rrorBusy,
    .rrorTimeout,
    .rrorUnknownKeyID,
    .rrorInactiveKey,
    .rrorInvalidSignature,
    .rrorInvalidTokenOrCounter,
    .rrorInsufficientPrivileges,
    .rrorInvalidDomains,
    .rrorInvalidCommand,
    .rrorDecoding,
    .rrorInternal,
    .rrorWrongPersonalization,
    .rrorBadParameter,
    .rrorKeychainIsFull,
    .rrorIncorrectEpoch,
    .rrorIvIncorrectLength,
    .rrorTimeExpired,
    .rrorNotProvisionedWithIdentity,
    .rrorCouldNotHashMetadata,
    .rrorTimeToLiveTooLong,
    .rrorRemoteAccessDisabled,
    .rrorRemoteServiceAccessDisabled,
    .rrorCommandRequiresAccountCredentials,
    .rrorRequestMtuExceeded,
    .rrorResponseMtuExceeded,
  ]
}

#endif  // swift(>=4.2)

enum OperationStatus_E: SwiftProtobuf.Enum {
  typealias RawValue = Int
  case operationstatusOk // = 0
  case operationstatusWait // = 1
  case rror // = 2
  case UNRECOGNIZED(Int)

  init() {
    self = .operationstatusOk
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .operationstatusOk
    case 1: self = .operationstatusWait
    case 2: self = .rror
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .operationstatusOk: return 0
    case .operationstatusWait: return 1
    case .rror: return 2
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension OperationStatus_E: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static let allCases: [OperationStatus_E] = [
    .operationstatusOk,
    .operationstatusWait,
    .rror,
  ]
}

#endif  // swift(>=4.2)

struct Destination {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var subMessage: Destination.OneOf_SubMessage? = nil

  var domain: Domain {
    get {
      if case .domain(let v)? = subMessage {return v}
      return .broadcast
    }
    set {subMessage = .domain(newValue)}
  }

  var routingAddress: Data {
    get {
      if case .routingAddress(let v)? = subMessage {return v}
      return Data()
    }
    set {subMessage = .routingAddress(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_SubMessage: Equatable {
    case domain(Domain)
    case routingAddress(Data)

  #if !swift(>=4.1)
    static func ==(lhs: Destination.OneOf_SubMessage, rhs: Destination.OneOf_SubMessage) -> Bool {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch (lhs, rhs) {
      case (.domain, .domain): return {
        guard case .domain(let l) = lhs, case .domain(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.routingAddress, .routingAddress): return {
        guard case .routingAddress(let l) = lhs, case .routingAddress(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      default: return false
      }
    }
  #endif
  }

  init() {}
}

struct MessageStatus {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var operationStatus: OperationStatus_E = .operationstatusOk

  var signedMessageFault: MessageFault_E = .rrorNone

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct RoutableMessage {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var toDestination: Destination {
    get {return _toDestination ?? Destination()}
    set {_toDestination = newValue}
  }
  /// Returns true if `toDestination` has been explicitly set.
  var hasToDestination: Bool {return self._toDestination != nil}
  /// Clears the value of `toDestination`. Subsequent reads from it will return its default value.
  mutating func clearToDestination() {self._toDestination = nil}

  var fromDestination: Destination {
    get {return _fromDestination ?? Destination()}
    set {_fromDestination = newValue}
  }
  /// Returns true if `fromDestination` has been explicitly set.
  var hasFromDestination: Bool {return self._fromDestination != nil}
  /// Clears the value of `fromDestination`. Subsequent reads from it will return its default value.
  mutating func clearFromDestination() {self._fromDestination = nil}

  var signedMessageStatus: MessageStatus {
    get {return _signedMessageStatus ?? MessageStatus()}
    set {_signedMessageStatus = newValue}
  }
  /// Returns true if `signedMessageStatus` has been explicitly set.
  var hasSignedMessageStatus: Bool {return self._signedMessageStatus != nil}
  /// Clears the value of `signedMessageStatus`. Subsequent reads from it will return its default value.
  mutating func clearSignedMessageStatus() {self._signedMessageStatus = nil}

  var requestUuid: Data = Data()

  var uuid: Data = Data()

  var flags: UInt32 = 0

  var subMessage: RoutableMessage.OneOf_SubMessage? = nil

  var protobufMessageAsBytes: Data {
    get {
      if case .protobufMessageAsBytes(let v)? = subMessage {return v}
      return Data()
    }
    set {subMessage = .protobufMessageAsBytes(newValue)}
  }

  var signatureData: SignatureData {
    get {
      if case .signatureData(let v)? = subMessage {return v}
      return SignatureData()
    }
    set {subMessage = .signatureData(newValue)}
  }

  var sessionInfoRequest: SessionInfoRequest {
    get {
      if case .sessionInfoRequest(let v)? = subMessage {return v}
      return SessionInfoRequest()
    }
    set {subMessage = .sessionInfoRequest(newValue)}
  }

  var sessionInfo: Data {
    get {
      if case .sessionInfo(let v)? = subMessage {return v}
      return Data()
    }
    set {subMessage = .sessionInfo(newValue)}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum OneOf_SubMessage: Equatable {
    case protobufMessageAsBytes(Data)
    case signatureData(SignatureData)
    case sessionInfoRequest(SessionInfoRequest)
    case sessionInfo(Data)

  #if !swift(>=4.1)
    static func ==(lhs: RoutableMessage.OneOf_SubMessage, rhs: RoutableMessage.OneOf_SubMessage) -> Bool {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch (lhs, rhs) {
      case (.protobufMessageAsBytes, .protobufMessageAsBytes): return {
        guard case .protobufMessageAsBytes(let l) = lhs, case .protobufMessageAsBytes(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.signatureData, .signatureData): return {
        guard case .signatureData(let l) = lhs, case .signatureData(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.sessionInfoRequest, .sessionInfoRequest): return {
        guard case .sessionInfoRequest(let l) = lhs, case .sessionInfoRequest(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      case (.sessionInfo, .sessionInfo): return {
        guard case .sessionInfo(let l) = lhs, case .sessionInfo(let r) = rhs else { preconditionFailure() }
        return l == r
      }()
      default: return false
      }
    }
  #endif
  }

  init() {}

  fileprivate var _toDestination: Destination? = nil
  fileprivate var _fromDestination: Destination? = nil
  fileprivate var _signedMessageStatus: MessageStatus? = nil
}

struct SessionInfoRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var publicKey: Data = Data()

  var challenge: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Domain: @unchecked Sendable {}
extension MessageFault_E: @unchecked Sendable {}
extension OperationStatus_E: @unchecked Sendable {}
extension Destination: @unchecked Sendable {}
extension Destination.OneOf_SubMessage: @unchecked Sendable {}
extension MessageStatus: @unchecked Sendable {}
extension RoutableMessage: @unchecked Sendable {}
extension RoutableMessage.OneOf_SubMessage: @unchecked Sendable {}
extension SessionInfoRequest: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension Domain: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "DOMAIN_BROADCAST"),
    2: .same(proto: "DOMAIN_VEHICLE_SECURITY"),
    3: .same(proto: "DOMAIN_INFOTAINMENT"),
    5: .same(proto: "DOMAIN_AUTHD"),
    7: .same(proto: "DOMAIN_ENERGY_DEVICE"),
    8: .same(proto: "DOMAIN_ENERGY_DEVICE_AUTH"),
  ]
}

extension MessageFault_E: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "MESSAGEFAULT_ERROR_NONE"),
    1: .same(proto: "MESSAGEFAULT_ERROR_BUSY"),
    2: .same(proto: "MESSAGEFAULT_ERROR_TIMEOUT"),
    3: .same(proto: "MESSAGEFAULT_ERROR_UNKNOWN_KEY_ID"),
    4: .same(proto: "MESSAGEFAULT_ERROR_INACTIVE_KEY"),
    5: .same(proto: "MESSAGEFAULT_ERROR_INVALID_SIGNATURE"),
    6: .same(proto: "MESSAGEFAULT_ERROR_INVALID_TOKEN_OR_COUNTER"),
    7: .same(proto: "MESSAGEFAULT_ERROR_INSUFFICIENT_PRIVILEGES"),
    8: .same(proto: "MESSAGEFAULT_ERROR_INVALID_DOMAINS"),
    9: .same(proto: "MESSAGEFAULT_ERROR_INVALID_COMMAND"),
    10: .same(proto: "MESSAGEFAULT_ERROR_DECODING"),
    11: .same(proto: "MESSAGEFAULT_ERROR_INTERNAL"),
    12: .same(proto: "MESSAGEFAULT_ERROR_WRONG_PERSONALIZATION"),
    13: .same(proto: "MESSAGEFAULT_ERROR_BAD_PARAMETER"),
    14: .same(proto: "MESSAGEFAULT_ERROR_KEYCHAIN_IS_FULL"),
    15: .same(proto: "MESSAGEFAULT_ERROR_INCORRECT_EPOCH"),
    16: .same(proto: "MESSAGEFAULT_ERROR_IV_INCORRECT_LENGTH"),
    17: .same(proto: "MESSAGEFAULT_ERROR_TIME_EXPIRED"),
    18: .same(proto: "MESSAGEFAULT_ERROR_NOT_PROVISIONED_WITH_IDENTITY"),
    19: .same(proto: "MESSAGEFAULT_ERROR_COULD_NOT_HASH_METADATA"),
    20: .same(proto: "MESSAGEFAULT_ERROR_TIME_TO_LIVE_TOO_LONG"),
    21: .same(proto: "MESSAGEFAULT_ERROR_REMOTE_ACCESS_DISABLED"),
    22: .same(proto: "MESSAGEFAULT_ERROR_REMOTE_SERVICE_ACCESS_DISABLED"),
    23: .same(proto: "MESSAGEFAULT_ERROR_COMMAND_REQUIRES_ACCOUNT_CREDENTIALS"),
    24: .same(proto: "MESSAGEFAULT_ERROR_REQUEST_MTU_EXCEEDED"),
    25: .same(proto: "MESSAGEFAULT_ERROR_RESPONSE_MTU_EXCEEDED"),
  ]
}

extension OperationStatus_E: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "OPERATIONSTATUS_OK"),
    1: .same(proto: "OPERATIONSTATUS_WAIT"),
    2: .same(proto: "OPERATIONSTATUS_ERROR"),
  ]
}

extension Destination: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Destination"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "domain"),
    2: .standard(proto: "routing_address"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try {
        var v: Domain?
        try decoder.decodeSingularEnumField(value: &v)
        if let v = v {
          if self.subMessage != nil {try decoder.handleConflictingOneOf()}
          self.subMessage = .domain(v)
        }
      }()
      case 2: try {
        var v: Data?
        try decoder.decodeSingularBytesField(value: &v)
        if let v = v {
          if self.subMessage != nil {try decoder.handleConflictingOneOf()}
          self.subMessage = .routingAddress(v)
        }
      }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    switch self.subMessage {
    case .domain?: try {
      guard case .domain(let v)? = self.subMessage else { preconditionFailure() }
      try visitor.visitSingularEnumField(value: v, fieldNumber: 1)
    }()
    case .routingAddress?: try {
      guard case .routingAddress(let v)? = self.subMessage else { preconditionFailure() }
      try visitor.visitSingularBytesField(value: v, fieldNumber: 2)
    }()
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Destination, rhs: Destination) -> Bool {
    if lhs.subMessage != rhs.subMessage {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension MessageStatus: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "MessageStatus"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "operation_status"),
    2: .standard(proto: "signed_message_fault"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operationStatus) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.signedMessageFault) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operationStatus != .operationstatusOk {
      try visitor.visitSingularEnumField(value: self.operationStatus, fieldNumber: 1)
    }
    if self.signedMessageFault != .rrorNone {
      try visitor.visitSingularEnumField(value: self.signedMessageFault, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: MessageStatus, rhs: MessageStatus) -> Bool {
    if lhs.operationStatus != rhs.operationStatus {return false}
    if lhs.signedMessageFault != rhs.signedMessageFault {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension RoutableMessage: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "RoutableMessage"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    6: .standard(proto: "to_destination"),
    7: .standard(proto: "from_destination"),
    12: .same(proto: "signedMessageStatus"),
    50: .standard(proto: "request_uuid"),
    51: .same(proto: "uuid"),
    52: .same(proto: "flags"),
    10: .standard(proto: "protobuf_message_as_bytes"),
    13: .standard(proto: "signature_data"),
    14: .standard(proto: "session_info_request"),
    15: .standard(proto: "session_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 6: try { try decoder.decodeSingularMessageField(value: &self._toDestination) }()
      case 7: try { try decoder.decodeSingularMessageField(value: &self._fromDestination) }()
      case 10: try {
        var v: Data?
        try decoder.decodeSingularBytesField(value: &v)
        if let v = v {
          if self.subMessage != nil {try decoder.handleConflictingOneOf()}
          self.subMessage = .protobufMessageAsBytes(v)
        }
      }()
      case 12: try { try decoder.decodeSingularMessageField(value: &self._signedMessageStatus) }()
      case 13: try {
        var v: SignatureData?
        var hadOneofValue = false
        if let current = self.subMessage {
          hadOneofValue = true
          if case .signatureData(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {
          if hadOneofValue {try decoder.handleConflictingOneOf()}
          self.subMessage = .signatureData(v)
        }
      }()
      case 14: try {
        var v: SessionInfoRequest?
        var hadOneofValue = false
        if let current = self.subMessage {
          hadOneofValue = true
          if case .sessionInfoRequest(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {
          if hadOneofValue {try decoder.handleConflictingOneOf()}
          self.subMessage = .sessionInfoRequest(v)
        }
      }()
      case 15: try {
        var v: Data?
        try decoder.decodeSingularBytesField(value: &v)
        if let v = v {
          if self.subMessage != nil {try decoder.handleConflictingOneOf()}
          self.subMessage = .sessionInfo(v)
        }
      }()
      case 50: try { try decoder.decodeSingularBytesField(value: &self.requestUuid) }()
      case 51: try { try decoder.decodeSingularBytesField(value: &self.uuid) }()
      case 52: try { try decoder.decodeSingularUInt32Field(value: &self.flags) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._toDestination {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
    } }()
    try { if let v = self._fromDestination {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 7)
    } }()
    try { if case .protobufMessageAsBytes(let v)? = self.subMessage {
      try visitor.visitSingularBytesField(value: v, fieldNumber: 10)
    } }()
    try { if let v = self._signedMessageStatus {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 12)
    } }()
    switch self.subMessage {
    case .signatureData?: try {
      guard case .signatureData(let v)? = self.subMessage else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 13)
    }()
    case .sessionInfoRequest?: try {
      guard case .sessionInfoRequest(let v)? = self.subMessage else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 14)
    }()
    case .sessionInfo?: try {
      guard case .sessionInfo(let v)? = self.subMessage else { preconditionFailure() }
      try visitor.visitSingularBytesField(value: v, fieldNumber: 15)
    }()
    default: break
    }
    if !self.requestUuid.isEmpty {
      try visitor.visitSingularBytesField(value: self.requestUuid, fieldNumber: 50)
    }
    if !self.uuid.isEmpty {
      try visitor.visitSingularBytesField(value: self.uuid, fieldNumber: 51)
    }
    if self.flags != 0 {
      try visitor.visitSingularUInt32Field(value: self.flags, fieldNumber: 52)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: RoutableMessage, rhs: RoutableMessage) -> Bool {
    if lhs._toDestination != rhs._toDestination {return false}
    if lhs._fromDestination != rhs._fromDestination {return false}
    if lhs._signedMessageStatus != rhs._signedMessageStatus {return false}
    if lhs.requestUuid != rhs.requestUuid {return false}
    if lhs.uuid != rhs.uuid {return false}
    if lhs.flags != rhs.flags {return false}
    if lhs.subMessage != rhs.subMessage {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SessionInfoRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "SessionInfoRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "public_key"),
    2: .same(proto: "challenge"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.publicKey) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.challenge) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.publicKey.isEmpty {
      try visitor.visitSingularBytesField(value: self.publicKey, fieldNumber: 1)
    }
    if !self.challenge.isEmpty {
      try visitor.visitSingularBytesField(value: self.challenge, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SessionInfoRequest, rhs: SessionInfoRequest) -> Bool {
    if lhs.publicKey != rhs.publicKey {return false}
    if lhs.challenge != rhs.challenge {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
