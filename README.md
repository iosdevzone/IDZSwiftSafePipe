# IDZSwiftSafePipe
A replacement for Foundation's `Pipe` class with kinder, gentler error handling.

## The Problem
When the underlying system call – `pipe(2)` – fails, Foundation on macOS `Pipe()` succeeds but the returned pipe has both file handles set to zero. On Unix, it crashes with a call to `fatalError`. 

## A Solution
The `SafePipe` class replaces `Pipe`'s non-failable initializer with a failable one. If the underlying system call fails it returns `nil`. The calling program can then take corrective action or at least present the user with some explaination of what went wrong.

## A Caveat
Foundation's `Pipe` is a sub-class of `NSObject`, but a sub-class of `NSObject` cannot (apparently) have a failable initializer, so `SafePipe` does cannot inherit from `NSObject`. 

For more information see the embedded documentation.
