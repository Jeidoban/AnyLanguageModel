import Foundation
import Testing

@testable import AnyLanguageModel

@Generable
private struct OpenAISchemaResponse: Codable, Equatable, Sendable {
    var title: String
    var items: [OpenAISchemaItem]
}

@Generable
private struct OpenAISchemaItem: Codable, Equatable, Sendable {
    var name: String
    var count: Int
}

@Suite("OpenAI Schema")
struct OpenAISchemaTests {
    @Test func arrayOfGenerableRetainsDefinitionsInJsonValue() throws {
        let schema = try OpenAISchemaResponse.generationSchema.strictStructuredOutputJSONValue()

        let jsonValue = schema
        let data = try JSONEncoder().encode(jsonValue)
        let json = String(decoding: data, as: UTF8.self)

        #expect(json.contains("\"$defs\""))
        #expect(json.contains("OpenAISchemaItem"))
        #expect(json.contains("\"$ref\""))
    }
}
