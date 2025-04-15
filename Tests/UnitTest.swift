import XCTest
import Foundation

@testable import MoproFFI

struct ZkEmailInputTest: Codable {
    struct Header: Codable {
        let storage: [String]
        let len: Int
    }
    struct Pubkey: Codable {
        let modulus: [String]
        let redc: [String]
    }
    struct Sequence: Codable {
        let index: Int
        let length: Int
    }
    let header: Header
    let pubkey: Pubkey
    let signature: [String]
    let date_index: Int
    let subject_sequence: Sequence
    let from_header_sequence: Sequence
    let from_address_sequence: Sequence
}

class MoproFFITests: XCTestCase {
  func testZkEmailProveAndVerify() async throws {
    guard let srsPath = Bundle.module.path(forResource: "srs", ofType: "local") else {
      XCTFail("Failed to find srs.local in test bundle. Ensure it's added to the Tests target.")
      return
    }
    guard let inputJsonPath = Bundle.module.path(forResource: "zkemail_input", ofType: "json") else {
      XCTFail("Failed to find zkemail_input.json in test bundle. Ensure it's added to the Tests target.")
      return
    }

    let inputData: ZkEmailInputTest
    do {
      let jsonData = try Data(contentsOf: URL(fileURLWithPath: inputJsonPath))
      let decoder = JSONDecoder()
      inputData = try decoder.decode(ZkEmailInputTest.self, from: jsonData)
    } catch {
      XCTFail("Failed to load or parse zkemail_input.json: \(error)")
      return
    }

    var inputs: [String: [String]] = [:]
    inputs["header_storage"] = inputData.header.storage.map { String($0) }
    inputs["header_len"] = [String(inputData.header.len)]
    inputs["pubkey_modulus"] = inputData.pubkey.modulus
    inputs["pubkey_redc"] = inputData.pubkey.redc
    inputs["signature"] = inputData.signature
    inputs["date_index"] = [String(inputData.date_index)]
    inputs["subject_index"] = [String(inputData.subject_sequence.index)]
    inputs["subject_length"] = [String(inputData.subject_sequence.length)]
    inputs["from_header_index"] = [String(inputData.from_header_sequence.index)]
    inputs["from_header_length"] = [String(inputData.from_header_sequence.length)]
    inputs["from_address_index"] = [String(inputData.from_address_sequence.index)]
    inputs["from_address_length"] = [String(inputData.from_address_sequence.length)]

    let proofData: Data
    do {
      proofData = try proveZkemail(srsPath: srsPath, inputs: inputs)
      XCTAssertTrue(proofData.count > 0, "Generated proof data should not be empty")
    } catch {
      XCTFail("proveZkemail threw an error: \(error)")
      return
    }

    do {
      let isValid = try verifyZkemail(srsPath: srsPath, proof: proofData)
      XCTAssertTrue(isValid, "Verification failed for generated proof")
    } catch {
      XCTFail("verifyZkemail threw an error: \(error)")
    }
  }
}
