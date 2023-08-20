# upgraded-broccoli
Elasticsearch on Kubernetes (ECK) worked example, benchmarking using esrally/opensearch-benchmarking.

## APIs enabled
```
$ gcloud services list --enabled
NAME                                 TITLE
artifactregistry.googleapis.com      Artifact Registry API
autoscaling.googleapis.com           Cloud Autoscaling API
bigquery.googleapis.com              BigQuery API
bigquerymigration.googleapis.com     BigQuery Migration API
bigquerystorage.googleapis.com       BigQuery Storage API
cloudapis.googleapis.com             Google Cloud APIs
cloudresourcemanager.googleapis.com  Cloud Resource Manager API
cloudtrace.googleapis.com            Cloud Trace API
compute.googleapis.com               Compute Engine API
container.googleapis.com             Kubernetes Engine API
containerfilesystem.googleapis.com   Container File System API
datastore.googleapis.com             Cloud Datastore API
dns.googleapis.com                   Cloud DNS API
firebaserules.googleapis.com         Firebase Rules API
firestore.googleapis.com             Cloud Firestore API
iam.googleapis.com                   Identity and Access Management (IAM) API
iamcredentials.googleapis.com        IAM Service Account Credentials API
logging.googleapis.com               Cloud Logging API
monitoring.googleapis.com            Cloud Monitoring API
oslogin.googleapis.com               Cloud OS Login API
pubsub.googleapis.com                Cloud Pub/Sub API
secretmanager.googleapis.com         Secret Manager API
servicemanagement.googleapis.com     Service Management API
serviceusage.googleapis.com          Service Usage API
sql-component.googleapis.com         Cloud SQL
storage-api.googleapis.com           Google Cloud Storage JSON API
storage-component.googleapis.com     Cloud Storage
storage.googleapis.com               Cloud Storage API
```

## Terraform User permissions

Terraform user should have the following permissions

```
gcloud beta asset search-all-iam-policies --query="policy:bobbins-terraform-ng@bobbins-mcbobbinsface-123456.iam.gserviceaccount.com" | egrep "role:|resource:|gserviceaccount"
    - serviceAccount:bobbins-terraform-ng@bobbins-mcbobbinsface-123456.iam.gserviceaccount.com
    role: roles/artifactregistry.admin
    - serviceAccount:bobbins-terraform-ng@bobbins-mcbobbinsface-123456.iam.gserviceaccount.com
    role: roles/compute.networkAdmin
    - serviceAccount:bobbins-terraform-ng@bobbins-mcbobbinsface-123456.iam.gserviceaccount.com
    role: roles/container.admin
    - serviceAccount:bobbins-terraform-ng@bobbins-mcbobbinsface-123456.iam.gserviceaccount.com
    role: roles/editor
    - serviceAccount:bobbins-terraform-ng@bobbins-mcbobbinsface-123456.iam.gserviceaccount.com
    role: roles/iam.securityAdmin
    - serviceAccount:bobbins-terraform-ng@bobbins-mcbobbinsface-123456.iam.gserviceaccount.com
    role: roles/iam.serviceAccountAdmin
    - serviceAccount:bobbins-terraform-ng@bobbins-mcbobbinsface-123456.iam.gserviceaccount.com
    role: roles/resourcemanager.projectIamAdmin
    - serviceAccount:bobbins-terraform-ng@bobbins-mcbobbinsface-123456.iam.gserviceaccount.com
    role: roles/secretmanager.admin
resource: //cloudresourcemanager.googleapis.com/projects/bobbins-mcbobbinsface-123456

Compute Network Admin
Editor
Kubernetes Engine Admin
Project IAM Admin
Secret Manager Admin
Security Admin
Service Account Admin
```

Create a file terraform.tfvars which contains the GCP deployment credentilas

```
credentials_file = "bobbins-mcbobbinsface-123456-a12345689ab.json"
gcpproject       = "bobbins-mcbobbinsface-123456"
region           = "europe-west2"
```

## Build the infrastructure


$ cd infrastructure
$ terraform init; terraform plan; terraform apply

## Find the GKE cluster credentials


```
$ gcloud container clusters get-credentials bobbins-gke --region europe-west2 
$ export KUBE_CONFIG_FILE=~/.kube/config
$ terraform apply
``` 

## Deploy the ECK stack in kubernetes

Enable the ingress if required using the TF ```var.es_ingress```

```
$ cd infrastructure
$ terraform init; terraform plan; terraform apply
```

## Test Elasticsearch

Run a pod to test ingress:
```
$ kubectl run curly --image=curlimages/curl -i --tty -- sh
```
If the pod is already running:
``` 
$ kubectl attach curly -c curly -i -t
``` 

Test connection to the service:
```
~ $ curl -I https://test-es-http.es-test:9200 -k
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Basic realm="security" charset="UTF-8"
WWW-Authenticate: Bearer realm="security"
WWW-Authenticate: ApiKey
content-type: application/json
content-length: 459
```

## Build esrally using podman for ECK benchmarking

Install podman and login to the GCP artifact registry.

```
$ cd benchmark/esrally
$ gcloud auth print-access-token --quiet | podman login -u oauth2accesstoken --password-stdin https://europe-west2-docker.pkg.dev
$ podman build -t europe-west2-docker.pkg.dev/bobbins-mcbobbinsface-123456/benchmarking/esrally:0.1 .
$ podman push europe-west2-docker.pkg.dev/bobbins-mcbobbinsface-123456/benchmarking/esrally:0.1

```

## Running esrally

Find the secret associated with the Elasticsearch ECK build
```
$ kubectl get secrets/test-es-elastic-user  -n es-test -o yaml
apiVersion: v1
data:
  elastic: ZDdNZ0ptZjY1Qjg4OTFqdUE2eDk2c3hS
kind: Secret
metadata:
  creationTimestamp: "2023-08-19T11:13:03Z"
  labels:
    common.k8s.elastic.co/type: elasticsearch
    eck.k8s.elastic.co/credentials: "true"
    eck.k8s.elastic.co/owner-kind: Elasticsearch
    eck.k8s.elastic.co/owner-name: test
    eck.k8s.elastic.co/owner-namespace: es-test
    elasticsearch.k8s.elastic.co/cluster-name: test
  name: test-es-elastic-user
  namespace: es-test
  resourceVersion: "6058"
  uid: ba31af80-b840-40d2-8e9f-20f05032aa4e
type: Opaque
```

Base64 decode

```
$ echo "ZDdNZ0ptZjY1Qjg4OTFqdUE2eDk2c3hS" | base64 -d
d7MgJmf65B8891juA6x96sxR
```

Test using the secret via curl

```
$ kubectl attach curly -c curly -i -t
~ $ curl -u elastic:d7MgJmf65B8891juA6x96sxR https://test-es-http.es-test:9200 -k
{
  "name" : "test-es-default-0",
  "cluster_name" : "test",
  "cluster_uuid" : "cLRNu1ExQMq0NXFkPAQyoA",
  "version" : {
    "number" : "8.8.1",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "f8edfccba429b6477927a7c1ce1bc6729521305e",
    "build_date" : "2023-06-05T21:32:25.188464208Z",
    "build_snapshot" : false,
    "lucene_version" : "9.6.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

Run esrally
```
kubectl run esrally --image=europe-west2-docker.pkg.dev/<project>/benchmarking/esrally:0.1 -i --tty -- sh
If you don't see a command prompt, try pressing enter.
/ #
/ # PASSWORD="d7MgJmf65B8891juA6x96sxR"; esrally race --track=percolator --target-hosts=test-es-http.es-test.svc:9200 --pipeline=benchmark-only --client-options="use_ssl:true,verify_certs:false,basic_auth_user:'elastic',basic_auth_password:$PASSWORD"
```
