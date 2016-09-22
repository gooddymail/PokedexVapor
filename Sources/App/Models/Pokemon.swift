//
//  Pokedex.swift
//  Pokedex
//
//  Created by Katchapon Poolpipat on 9/21/2559 BE.
//
//

import Foundation
import Vapor
import FluentMySQL
import HTTP


final class Pokemon:Model {

  var id: Node?
  var name: String
  var time: Int
  
  init(name: String, time: Int) {
    self.name = name
    self.time = time
  }
  
  convenience init(name: String) {
    let date = Date()
    self.init(name: name, time: Int(date.timeIntervalSince1970))
  }
  
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    name = try node.extract("name")
    time = try node.extract("time")
  }
  
  
  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "name": name,
      "time": time
      ])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("pokemons") { pokemons in
        pokemons.id()
        pokemons.string("name")
        pokemons.int("time")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("pokemons")
  }
  
}

extension Pokemon {
  var date: Date {
    return Date(timeIntervalSince1970: Double(time))
  }
  
  var readableDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }
}

