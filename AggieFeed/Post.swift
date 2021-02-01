//
//  Post.swift
//  AggieFeed
//
//  Created by Tom Abraham on 2/1/21.
//

import Foundation

struct Post: Codable{
    var title: String!
    var actor: Actor!
}

struct Actor: Codable {
    var displayName: String!
}
