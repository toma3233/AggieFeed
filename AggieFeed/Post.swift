//
//  Post.swift
//  AggieFeed
//
//  Created by Tom Abraham on 2/1/21.
//

import Foundation

// structs used to format JSON file into activities
struct Post: Codable{
    var title: String!
    var actor: Actor!
    var object: Object
    var published: String!
}

struct Actor: Codable {
    var displayName: String!
}

struct Object: Codable {
    var objectType: ObjectObjectType!
}

enum ObjectObjectType: String, Codable {
    case event = "event"
    case notification = "notification"
}
