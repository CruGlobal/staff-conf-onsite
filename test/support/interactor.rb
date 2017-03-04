module Support
  module Interactor
    def assert_success(result, expected_context = nil)
      assert result.success?, "Expected #{result.inspect} to be a success"
      assert_context_hash(result, expected_context) if expected_context.present?
    end

    def assert_failure(result, expected_context = nil)
      assert result.failure?, "Expected #{result.inspect} to be a failure"
      assert_context_hash(result, expected_context) if expected_context.present?
    end

    def assert_context_hash(result, hash)
      hash.each { |key, expected| assert_context(expected, result, key) }
    end

    def assert_context(expected, result, key)
      actual = result.send(key)

      assert (expected == actual),
        format(
          "Expected context.error: %p\n  Actual context.error: %p",
          expected,
          actual
        )
    end
  end
end
