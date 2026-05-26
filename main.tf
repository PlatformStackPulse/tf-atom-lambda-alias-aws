resource "aws_lambda_alias" "this" {
  count = module.this.enabled ? 1 : 0

  name             = coalesce(var.alias_name, module.this.id)
  function_name    = var.function_name
  function_version = var.function_version
  description      = var.description

  dynamic "routing_config" {
    for_each = var.additional_version_weights != null ? [1] : []
    content {
      additional_version_weights = var.additional_version_weights
    }
  }
}
