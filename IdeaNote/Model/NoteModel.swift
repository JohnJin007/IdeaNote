//
//  Model.swift
//  IdeaNote
//
//  Created by v_jinlilili on 25/12/2024.
//

import SwiftUI
import Foundation

struct NoteModel: Identifiable, Codable {
    var id = UUID()
    var writeTime: String
    var title: String
    var content: String
}
