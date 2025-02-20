// Crypto.swift
// Copyright (c) 2025 ssh2.app
// Created by admin@ssh2.app 2024/8/18.

import Foundation
    import SwiftCSSL

/// Crypto类提供了一个单例实例，用于表示当前使用的加密库。
/// 根据编译时标志，它可以是OpenSSL或wolfSSL。
public class Crypto {
    // 单例实例，确保整个应用中只有一个Crypto实例。
    public static let shared: Crypto = .init()

    /// 当前使用的加密库名称。
    /// 根据编译时标志，可能是"OpenSSL"或"wolfSSL"。
        public static let name = "OpenSSL"

    /// 当前使用的加密库版本。
    /// 根据编译时标志，返回OPENSSL_VERSION_STR或LIBWOLFSSL_VERSION_STRING。
        public static let version = OPENSSL_VERSION_STR
}
