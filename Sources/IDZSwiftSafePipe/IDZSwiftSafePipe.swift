// ------------------------------------------------------------------------------
// This source code is derived from FileHandle.swift, a component of the Swift.org
// open source project.
//
// The orignal source code can be found at:
//
// https://github.com/apple/swift-corelibs-foundation/blob/edf34ca8557f92f548bb7fe6f54ac1dc630ae9b6/Foundation/FileHandle.swift
//
// Original copyright notice:
// ------------------------------------------------------------------------------
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
import Foundation

#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux) || CYGWIN
import Glibc
#endif

/// Provides a replacement for Foundation's `Pipe` class.
///
/// On macOS when the underlying system call fails, Foundation
/// creates an object with file handles set to zero. On Unix,
/// the program crashes with a `fatalError`.
///
/// This class, `SafePipe` has a failable initializer and
/// will return `nil` if the underlying system call fails.
///
open class SafePipe {
    private let readHandle: FileHandle
    private let writeHandle: FileHandle
    
    /// Creates a new pipe. Returns `nil` if the underlying system
    /// call fails.
    /// The `pipe (2)` system call only fail under the following
    /// conditions:
    /// - `EFAULT` An invalid buffer is passed. In this implementation this
    /// could only happen if the system fails to allocate two 32-bit integers
    /// if this occurs it is unlikely that the situation is recoverable. This
    /// mode of failure has not been tested for this implementation and may
    /// cause a crash.
    /// - `EMFILE` Too many file descriptors are active. In this case `nil` is returned.
    /// - `ENFILE` The system file table is full. In this case `nil` is returned.
    ///
    public init?() {
        var fds = UnsafeMutablePointer<Int32>.allocate(capacity: 2)
        defer {
            free(fds)
        }
        // Pipe returns non-zero on success
        guard pipe(fds) == 0 else { return nil }
        self.readHandle = FileHandle(fileDescriptor: fds.pointee, closeOnDealloc: true)
        self.writeHandle = FileHandle(fileDescriptor: fds.successor().pointee, closeOnDealloc: true)
    }
    
    /// The file handle to use for reading.
    open var fileHandleForReading: FileHandle {
        return self.readHandle
    }
    
    /// The file handle to use for writing.
    open var fileHandleForWriting: FileHandle {
        return self.writeHandle
    }
}
