resource "tls_private_key" "tls" {
  algorithm  = "RSA"
  rsa_bits   = 2048
  depends_on = [module.eks]
}

resource "tls_self_signed_cert" "tls" {
  private_key_pem = tls_private_key.tls.private_key_pem

  subject {
    common_name  = "*.online-boutique.com"
    organization = "gcp"
  }

  validity_period_hours = 8760 # 1 year
  early_renewal_hours   = 720

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]

  dns_names = [
    "*.online-boutique.com",
    "online-boutique.com"
  ]

  depends_on = [tls_private_key.tls]
}

resource "kubernetes_namespace" "namespace" {
  for_each = local.tls_secrets

  metadata {
    name = each.key
  }

  depends_on = [tls_self_signed_cert.tls]
}

resource "kubernetes_secret" "secret_per_namespace" {
  for_each = local.tls_secrets

  metadata {
    name      = each.value
    namespace = each.key
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = base64encode(tls_self_signed_cert.tls.cert_pem)
    "tls.key" = base64encode(tls_private_key.tls.private_key_pem)
  }

  depends_on = [kubernetes_namespace.namespace]
}
