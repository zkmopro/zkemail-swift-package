import XCTest

@testable import MoproFFI

class MoproFFITests: XCTestCase {
  func testCircomProverAndVerifier() async throws {
    // Set up the file paths (assuming correct test files are available in the bundle)
    guard let zkeyPath = Bundle.module.path(forResource: "multiplier2_final", ofType: "zkey") else {
      XCTFail("zkey path not found in the bundle")
      return
    }
    // Run the function with the file contents as arguments
    do {
      // Prepare inputs
      let a = 3
      let b = 5
      let c = a * b
      let input_str: String = "{\"b\":[\"5\"],\"a\":[\"3\"]}"

      // Expected outputs
      let outputs: [String] = [String(c), String(a)]

      // Generate Proof
      let generateProofResult = try generateCircomProof(
        zkeyPath: zkeyPath, circuitInputs: input_str, proofLib: ProofLib.arkworks)

      let isValid = try verifyCircomProof(
        zkeyPath: zkeyPath,
        proofResult: CircomProofResult(
          proof: generateProofResult.proof, inputs: generateProofResult.inputs),
        proofLib: ProofLib.arkworks)
      XCTAssertTrue(isValid)
      XCTAssertEqual(outputs, generateProofResult.inputs)
      //XCTAssertFalse(generateProofResult, "Witness should be generated")
    } catch {
      XCTFail("generateProofResult failed with error: \(error)")
    }
  }
}
