//
//  Fixtures.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/3/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Argo
import Foundation
@testable import Tentacle

/// A dummy class, so we can ask for the current bundle in Fixture.URL
private class ImportedWithFixture { }

struct Fixture {
    private static let DataExtension = "data"
    private static let ResponseExtension = "response"
    
    static var allFixtures: [Fixture] = [
        Release.Carthage0_15,
        Release.Nonexistent,
    ]
    
    /// Returns the fixture for the given URL, or nil if no such fixture exists.
    static func fixtureForURL(URL: NSURL) -> Fixture? {
        if let index = allFixtures.indexOf({ $0.URL == URL }) {
            return allFixtures[index]
        }
        return nil
    }
    
    struct Release {
        static var Carthage0_15 = Fixture(.DotCom, .ReleaseByTagName(owner: "Carthage", repository: "Carthage", tag: "0.15"))
        static var Nonexistent = Fixture(.DotCom, .ReleaseByTagName(owner: "mdiep", repository: "NonExistent", tag: "tag"))
    }
    
    init(_ server: Server, _ endpoint: Client.Endpoint) {
        self.server = server
        self.endpoint = endpoint
    }
    
    /// The server that the fixture came from.
    let server: Server
    
    /// The Endpoint that the fixture came from.
    let endpoint: Client.Endpoint
    
    /// The filename used for the local fixture, without an extension
    private func filenameWithExtension(ext: String) -> NSString {
        let path: NSString = endpoint.path
        let filename: NSString = path
            .pathComponents
            .dropFirst()
            .joinWithSeparator("-")
        return filename.stringByAppendingPathExtension(ext)!
    }
    
    /// The filename used for the local fixture's data.
    var dataFilename: NSString {
        return filenameWithExtension(Fixture.DataExtension)
    }
    
    /// The filename used for the local fixture's HTTP response.
    var responseFilename: NSString {
        return filenameWithExtension(Fixture.ResponseExtension)
    }
    
    /// The URL of the fixture on the API.
    var URL: NSURL {
        return NSURLRequest.create(self.server, self.endpoint, nil).URL!
    }
    
    private func fileURLWithExtension(ext: String) -> NSURL {
        let bundle = NSBundle(forClass: ImportedWithFixture.self)
        let filename = filenameWithExtension(ext)
        return bundle.URLForResource(filename.stringByDeletingPathExtension, withExtension: filename.pathExtension)!
    }
    
    /// The URL of the fixture's data within the test bundle.
    var dataFileURL: NSURL {
        return fileURLWithExtension(Fixture.DataExtension)
    }
    
    /// The URL of the fixture's HTTP response within the test bundle.
    var responseFileURL: NSURL {
        return fileURLWithExtension(Fixture.ResponseExtension)
    }
    
    /// The data from the endpoint.
    var data: NSData {
       return NSData(contentsOfURL: dataFileURL)!
    }
    
    /// The HTTP response from the endpoint.
    var response: NSHTTPURLResponse {
        let data = NSData(contentsOfURL: responseFileURL)!
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSHTTPURLResponse
    }
    
    /// The JSON from the Endpoint.
    var JSON: NSDictionary {
        return try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
    }
    
    /// Decode the fixture's JSON as an object of the returned type.
    func decode<Object: Decodable where Object.DecodedType == Object>() -> Object? {
        return Argo.decode(JSON).value
    }
}
