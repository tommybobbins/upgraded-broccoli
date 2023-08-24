apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: es-test-ingress
  namespace: es-test
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /(.*)
        pathType: Prefix
        backend:
          service:
            name: test-es-http
            port:
              number: 9200
