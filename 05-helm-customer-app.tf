
resource "kubernetes_namespace" "aks-helloworld-one" {
  metadata {
    annotations = {
      name = "aks-helloworld-one-annotation"
    }

    labels = {
      name = "aks-helloworld-one-label"
    }

    name = "aks-helloworld-one-ns"
  }
}

resource "kubernetes_deployment" "aks-helloworld-one" {
  metadata {
    name      = "app-backend-dpl"
    namespace = kubernetes_namespace.aks-helloworld-one.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = kubernetes_namespace.aks-helloworld-one.metadata.0.labels.name
      }
    }
    template {
      metadata {
        labels = {
          app = kubernetes_namespace.aks-helloworld-one.metadata.0.labels.name
        }
      }

      spec {
        container {
          image = "mcr.microsoft.com/azuredocs/aks-helloworld:v1"
          name  = "aks-helloworld-one"
          port {
            container_port = 80
          }

        }
      }
    }
  }
}


resource "kubernetes_service" "aks-helloworld-one" {
  metadata {
    name      = "app-backend-svc"
    namespace = kubernetes_namespace.aks-helloworld-one.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_namespace.aks-helloworld-one.metadata.0.labels.name
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}
