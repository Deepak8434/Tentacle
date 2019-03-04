//
//  ReleaseTests.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/3/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

@testable import Tentacle
import XCTest

class ReleaseTests: XCTestCase {
    func testDecode() {
        let expected = Release(
            id: 2698201,
            tag: "0.15",
            url: URL(string: "https://github.com/Carthage/Carthage/releases/tag/0.15")!,
            name: "0.15: YOLOL",
            assets: [
                Release.Asset(
                    id: 1358331,
                    name: "Carthage.pkg",
                    contentType: "application/octet-stream",
                    url: URL(string: "https://github.com/Carthage/Carthage/releases/download/0.15/Carthage.pkg")!,
                    apiURL: URL(string: "https://api.github.com/repos/Carthage/Carthage/releases/assets/1358331")!
                ),
                Release.Asset(
                    id: 1358332,
                    name: "CarthageKit.framework.zip",
                    contentType: "application/zip",
                    url: URL(string: "https://github.com/Carthage/Carthage/releases/download/0.15/CarthageKit.framework.zip")!,
                    apiURL: URL(string: "https://api.github.com/repos/Carthage/Carthage/releases/assets/1358332")!
                )
            ]
        )
        XCTAssertEqual(Fixture.Release.Carthage0_15.decode(), expected)
    }

    func testDecodeLatestRelease() {
        let expected = Release(
            id: 961251,
            tag: "1.0.2",
            url: URL(string: "https://github.com/mdiep/MDPSplitView/releases/tag/1.0.2")!,
            name: "1.0.2",
            assets: [
                Release.Asset(
                    id: 433845,
                    name: "MDPSplitView.framework.zip",
                    contentType: "application/zip",
                    url: URL(string: "https://github.com/mdiep/MDPSplitView/releases/download/1.0.2/MDPSplitView.framework.zip")!,
                    apiURL: URL(string: "https://api.github.com/repos/mdiep/MDPSplitView/releases/assets/433845")!
                ),
            ]
        )
        XCTAssertEqual(Fixture.LatestRelease.release.decode(), expected)
    }
}
