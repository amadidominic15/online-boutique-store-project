output "github_oidc_arn" {
  description = "The ARN of the IAM role for Github CI/CD."
  value       = aws_iam_role.github_actions_oidc.arn
}