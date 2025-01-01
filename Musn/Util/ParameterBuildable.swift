//
//  ParameterBuildable.swift
//  Musn
//
//  Created by 권민재 on 1/1/25.
//

protocol ParameterBuildable {
    func buildParameters(required: [String: Any], optional: [String: Any?]) -> [String: Any]
}

extension ParameterBuildable {
    func buildParameters(required: [String: Any], optional: [String: Any?]) -> [String: Any] {
        var params = required
        optional.forEach { key, value in
            if let value = value {
                params[key] = value
            }
        }
        return params
    }
}
