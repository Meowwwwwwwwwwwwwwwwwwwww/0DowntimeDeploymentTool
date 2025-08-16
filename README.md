# 🚀 Zero Downtime Deployment Tool (Kubernetes)

A Kubernetes-based deployment tool designed to achieve **zero downtime deployments** using **Blue-Green** and **Canary strategies** with real-time traffic shifting, auto-scaling, and rollback support.

---

## ✨ Features

- ✅ **Real-time traffic shifting** via NGINX Ingress Controller  
- 📈 **Auto-scaling** using Horizontal Pod Autoscaler (HPA)  
- ♻️ **Safe rollback mechanism** in case of failures  
- 🛠️ **Automated CLI deployment script** for Blue/Green deployments  
- 📊 **Optional monitoring** with Prometheus + Grafana  

---

## 📂 Project Structure

```
zero-downtime-deployment-tool/
│── k8s/
│   ├── deployments/
│   │   ├── app-blue-deployment.yaml
│   │   ├── app-green-deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── hpa.yaml
│── scripts/
│   ├── deploy.sh
│── README.md
```

---

## ⚙️ Setup & Installation

### 1. Clone Repository
```bash
git clone https://github.com/your-username/zero-downtime-deployment-tool.git
cd zero-downtime-deployment-tool
```

### 2. Deploy Blue/Green Apps
```bash
kubectl apply -f k8s/deployments/app-blue-deployment.yaml
kubectl apply -f k8s/deployments/app-green-deployment.yaml
kubectl apply -f k8s/service.yaml
```

### 3. Setup Ingress (Traffic Shifting)
```bash
kubectl apply -f k8s/ingress.yaml
```

Check Ingress:
```bash
kubectl get ingress
```

### 4. Enable Auto-Scaling (HPA)
```bash
kubectl apply -f k8s/hpa.yaml
kubectl get hpa
```

### 5. Run Deployment Script
```bash
./scripts/deploy.sh blue   # Deploy to Blue
./scripts/deploy.sh green  # Deploy to Green
```

### 6. Check Health of Apps
```bash
kubectl get pods
kubectl port-forward pod/<pod-name> 8080:80
curl http://localhost:8080/health
```

---

## 🔄 Safe Rollback
If new deployment fails:
```bash
kubectl rollout undo deployment app-green
```

---

## 📊 Optional Monitoring (Prometheus + Grafana)
1. Install Prometheus & Grafana with Helm:
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack
```
2. Forward Grafana port:
```bash
kubectl port-forward svc/prometheus-grafana 3000:80
```
3. Open [http://localhost:3000](http://localhost:3000) → login with `admin/admin`.

---

## ✅ Verification of Blue & Green Apps
Check both apps separately before traffic shifting:
```bash
kubectl port-forward deployment/app-blue 8080:80
curl http://localhost:8080/health

kubectl port-forward deployment/app-green 8081:80
curl http://localhost:8081/health
```

---

## 📜 License
MIT License © 2025  
Developed by Pawan Garia 🚀
