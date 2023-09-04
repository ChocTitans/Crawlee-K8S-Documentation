# Deploy Crawlee to K8S

### **Requirements**

- EBS CSI DRIVER `Will be added in IaC` [@OfficialDocumentation](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)


### **Kustomization**

We're using kustomization to deploy all the ressources, in the main root there's `kustomization.yaml` that specifies every deployment/service/pvc folder and also using it for secrets/configmap.

---

Add them to your repository's secrets : 

- Go to your repository's settings.

- Under the settings, navigate to the 'Secrets' section.

- Click on 'New repository secret' or 'Add a secret environment' button.

- For the name, enter `CRAWLEE_ACCESS_KEY` and `CRAWLEE_SECRET_KEY`. #For AWS S3

- Input the new master key value in the 'Value' field.

A file named secret.env will be created and will contain all the secrets created in the github's repository

---

We'll have to specify the S3 bucket name & the region, you can add them in `configmap.env` directly or add them in the github's repository variables

```
aws-bucket-name=crawlee-app
aws-bucket-region=eu-west-3
```

The manifest file is `deployment.yaml` We chose deployment over a statefulset because Crawlee uses an S3 Bucket instead of a PVC. Additionally, we didn't create a service because Crawlee doesn't need to be exposed to any port.


run the following command:

`kustomize build . | kubectl apply -f - `

If you want to delete all the resources:

`kustomize build . | kubectl delete -f - `

---
