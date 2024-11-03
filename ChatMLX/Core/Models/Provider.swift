//
//  Provider.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/21.
//
import Defaults

enum Provider: String, Codable, Defaults.Serializable {
    case mlx = "MLX"
    case openAI = "OpenAI"
}
