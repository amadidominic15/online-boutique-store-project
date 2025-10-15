output "gitlab_ci_role_arn" {
  description = "The ARN of the IAM role for Github CI/CD."
  value       = aws_iam_role.github_actions_oidc.arn
}