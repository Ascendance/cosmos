//
//  Constants.swift
//  cosmos
//
//  Created by William Yang on 12/10/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

enum STATUSCODE{
    static let okay = 1
    static let fail = -1
}

enum CONFIG{
    #if XCTEST
    static let testURL = "https://nibbit.me/r/swift.json"
    static let server = "https://nibbit.me/r/"
    static let debug = true
    #else
    static let testURL = "https://reddit.com/r/swift.json"
    static let server = "https://reddit.com/r/"
    static let debug = false
    #endif
}

enum STRINGS{
    static let connectionFailedTitle = "Connection Error"
    static let connectionFailedBody = "No Connection to Reddit"
    static let subredditFailedTitle = "Subreddit Error"
    static let subredditFailedBody = "Could not connect to reddit or that subreddit does not exist!"
    static let emptyBody = "The selected post is either an image or URL and has no selftext."
}

enum RuntimeError: Error {
    case runtimeError(String)
}
