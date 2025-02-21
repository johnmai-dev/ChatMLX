////
////  ModelManagerViewModel.swift
////  ChatMLX
////
////  Created by John Mai on 2024/10/10.
////
//
//import SwiftUI
//
//@Observable
//class ModelManagerViewModel {
//    var models: [ModelInfo] = []
//
//    init() {
//        try? loadModels()
//    }
//
//    func loadModels() throws {
//
//    }
//
//    func deleteModel(_ model: ModelInfo) throws {
//        guard let path = model.path else {
//            return
//        }
//
////        if !model.isExternal {
////            let fileManager = FileManager.default
////            try fileManager.removeItem(at: path)
////        }
//
//        if let index = models.firstIndex(of: model) {
//            models.remove(at: index)
//        }
//    }
//}
