module "eks_blueprint_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.21.1"

  depends_on        = [kubernetes_secret.secret_per_namespace]
  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_ingress_nginx         = true
  enable_kube_prometheus_stack = true
  enable_argocd                = true

  ingress_nginx = {
    name          = "ingress-nginx"
    chart_version = "4.13.0"
    repository    = "https://kubernetes.github.io/ingress-nginx"
    namespace     = "kube-system"
    wait          = true
    wait_for_jobs = true
    values = [
      yamlencode({
        controller = {
          replicaCount = 2
          metrics      = { enabled = true }
          ingressClassResource = {
            name    = "nginx"
            enabled = true
            default = true
          }
          admissionWebhooks = {
            enabled = false # ✅ Disable the validating webhook not recommended for production
          }
        }
      })
    ]
  }

  kube_prometheus_stack = {
    chart                      = "kube-prometheus-stack"
    chart_version              = "77.0.0"
    repository                 = "https://prometheus-community.github.io/helm-charts"
    namespace                  = "monitoring"
    wait                       = true
    wait_for_jobs              = true
    disable_openapi_validation = true
    values = [
      yamlencode({
        grafana = {
          adminPassword = "admin"
          ingress = {
            enabled          = true
            ingressClassName = "nginx"
            annotations = {
              "kubernetes.io/ingress.class"                    = "nginx"
              "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
              "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
              "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
            }
            hosts = ["grafana.online-boutique.com"]
            path  = "/"
            tls = [{
              hosts      = ["grafana.online-boutique.com"]
              secretName = "monitoring-tls"
            }]
          }
        }
        prometheus = {
          prometheusSpec = {
            serviceMonitorSelectorNilUsesHelmValues = false
            serviceMonitorSelector = {
              matchLabels = {
                release = "kube-prometheus-stack"
              }
            }
          }
        }
      })
    ]
  }

  argocd = {
    chart         = "argo-cd"
    chart_version = "8.6.3"
    repository    = "https://argoproj.github.io/argo-helm"
    namespace     = "argocd"
    wait          = true
    wait_for_jobs = true
    values = [
      yamlencode({
        crds = {
          keep = false
        }
        global = {
          domain = "argocd.online-boutique.com"
        }
        server = {
          ingress = {
            enabled          = true
            ingressClassName = "nginx"
            annotations = {
              "kubernetes.io/ingress.class"                    = "nginx"
              "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTPS"
              "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
              "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
            }
            hosts = "argocd.online-boutique.com"
            path  = "/"
            tls = [{
              hosts      = "argocd.online-boutique.com"
              secretName = "argocd-tls"
            }]
          }
          config = {
            url = "https://argocd.online-boutique.com"
          }
        }
      })
    ]
  }
  tags = {
    "kubernetes.io/cluster/${local.name}-eks" = "shared"
  }
}

