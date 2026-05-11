import Foundation
extension GenerationSchema {
    /// Converts this schema into a JSONValue suitable for OpenAI-style structured outputs.
    /// All object nodes are normalized to strict mode recursively.
    func strictStructuredOutputJSONValue() throws -> JSONValue {
        let resolvedSchema = self.withResolvedRoot() ?? self
        return try JSONValue(resolvedSchema).applyingStrictStructuredOutputRules()
    }
}

extension JSONValue {
    /// Recursively applies strict-structured-output rules to schema objects.
    func applyingStrictStructuredOutputRules() -> JSONValue {
        switch self {
        case .object(var object):
            if case .object(let properties)? = object["properties"], !properties.isEmpty {
                object["required"] = .array(Array(properties.keys).sorted().map { .string($0) })
                object["additionalProperties"] = .bool(false)
            }

            object = object.mapValues { $0.applyingStrictStructuredOutputRules() }
            return .object(object)

        case .array(let items):
            return .array(items.map { $0.applyingStrictStructuredOutputRules() })

        default:
            return self
        }
    }
}
