
output "customer_ns" {
  value = kubernetes_namespace.customer_ns.metadata[0].name
}
