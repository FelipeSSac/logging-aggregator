resource "kubernetes_deployment" "log_generator" {
  metadata {
    name      = "log-generator"
    namespace = var.namespace
    labels = {
      app = "log-generator"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "log-generator"
      }
    }

    template {
      metadata {
        labels = {
          app = "log-generator"
        }
      }

      spec {
        container {
          name  = "log-generator"
          image = "busybox:latest"

          command = [
            "/bin/sh",
            "-c",
            "while true; do echo \"[INFO] Test log message generated at $(date)\"; echo \"[ERROR] Sample error message at $(date)\"; sleep ${var.log_frequency}; done"
          ]

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

output "deployment_name" {
  value = kubernetes_deployment.log_generator.metadata[0].name
}
