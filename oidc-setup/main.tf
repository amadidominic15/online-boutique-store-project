
#############################
# 1. OIDC Identity Provider
#############################
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.github.certificates[0].sha1_fingerprint
  ]
}

#################################
# 2. IAM Role for GitHub Actions
#################################
resource "aws_iam_role" "github_actions_oidc" {
  name = "github-actions-eks-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:amadidominic15/online-boutique-store-project:*"
          }
        }
      }
    ]
  })
}

#################################
# 3. Attach Full EKS Permissions
#################################
resource "aws_iam_role_policy_attachment" "eks_full_access" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Be cautious in production
}
