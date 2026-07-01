# Unit Tests for tf-atom-lambda-alias-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Assertions target values that are KNOWN at plan time (the tf-label id,
# resource counts, input pass-throughs, and the `enabled` flag). Computed
# attributes such as the alias ARN are unknown under a mock provider and are
# therefore only asserted on in the disabled (count = 0) case.
#
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run a single one: terraform test -test-directory=tests/unit -run creates_when_enabled

mock_provider "aws" {}

variables {
  # tf-label (context) inputs — drive the generated module id "eg-test-thing"
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-specific required / sample inputs
  function_name    = "eg-test-thing-fn"
  function_version = "7"
  description      = "unit-test alias"
}

# ---------------------------------------------------------------------------
# Test: module creates the alias when enabled (the default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "Module should report enabled == true by default."
  }

  assert {
    condition     = length(aws_lambda_alias.this) == 1
    error_message = "Exactly one aws_lambda_alias resource should be planned when enabled."
  }

  assert {
    condition     = aws_lambda_alias.this[0].name == "eg-test-thing"
    error_message = "Alias name should default to the tf-label module id 'eg-test-thing'."
  }

  assert {
    condition     = aws_lambda_alias.this[0].function_name == "eg-test-thing-fn"
    error_message = "function_name input should be passed through to the alias."
  }

  assert {
    condition     = aws_lambda_alias.this[0].function_version == "7"
    error_message = "function_version input should be passed through to the alias."
  }
}

# ---------------------------------------------------------------------------
# Test: explicit alias_name overrides the tf-label id
# ---------------------------------------------------------------------------
run "explicit_alias_name_overrides_id" {
  command = plan

  variables {
    alias_name = "live"
  }

  assert {
    condition     = aws_lambda_alias.this[0].name == "live"
    error_message = "Explicit alias_name should override the tf-label id."
  }
}

# ---------------------------------------------------------------------------
# Test: disabling the module creates nothing
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "Module should report enabled == false when disabled."
  }

  assert {
    condition     = length(aws_lambda_alias.this) == 0
    error_message = "No aws_lambda_alias resource should be planned when disabled."
  }

  assert {
    condition     = output.arn == null
    error_message = "arn output should be null when the module is disabled."
  }
}
