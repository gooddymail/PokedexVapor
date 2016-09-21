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

final class Pokemon: Model {
  var id: Node?
  var name: String?
}
