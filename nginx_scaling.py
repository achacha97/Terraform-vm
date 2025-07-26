import subprocess
import time

def setup_nginx_scaling():
    # 1. Création du déploiement Nginx
    print("\n=== Étape 1: Création du déploiement Nginx ===")
    with open('nginx-deployment.yaml', 'w') as f:
        f.write("""apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
""")
    subprocess.run("kubectl apply -f nginx-deployment.yaml", shell=True, check=True)
    
    # Attendre que le pod soit prêt
    print("Attente du déploiement...")
    time.sleep(20)
    
    # 2. Création du Service NodePort
    print("\n=== Étape 2: Création du Service NodePort ===")
    with open('nginx-service.yaml', 'w') as f:
        f.write("""apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30800
""")
    subprocess.run("kubectl apply -f nginx-service.yaml", shell=True, check=True)
    
    # 3. Vérification
    print("\n=== Vérification ===")
    subprocess.run("kubectl get deployments", shell=True)
    subprocess.run("kubectl get pods", shell=True)
    subprocess.run("kubectl get svc", shell=True)
    
    # 4. Scaling à 2 réplicas
    print("\n=== Étape 4: Scaling à 2 réplicas ===")
    subprocess.run("kubectl scale deployment nginx-deployment --replicas=2", shell=True, check=True)
    time.sleep(15)  # Attendre le scaling
    
    # 5. Modification des pages HTML
    print("\n=== Étape 5: Modification des pages HTML ===")
    pods = subprocess.getoutput("kubectl get pods -l app=nginx -o jsonpath='{.items[*].metadata.name}'").split()
    
    for i, pod in enumerate(pods, 1):
        html = f"<html><body><h1>Réplica {i}</h1></body></html>"
        cmd = f"kubectl exec {pod} -- sh -c \"echo '{html}' > /usr/share/nginx/html/index.html\""
        subprocess.run(cmd, shell=True, check=True)
        print(f"Pod {pod} configuré comme Réplica {i}")
    
    # 6. Vérification finale
    print("\n=== Vérification finale ===")
    print("Accès via :")
    subprocess.run("kubectl get svc nginx-service -o jsonpath='http://{.status.loadBalancer.ingress[0].ip}:{.spec.ports[0].nodePort}'", shell=True)
    print("\nRafraîchissez plusieurs fois pour voir alterner les réplicas")


 # 7. Export des informations de déploiement  
 print("\n=== Étape 7: Export des informations de déploiement ===")
    with open('deployment-info.txt', 'w') as f:
        describe_output = subprocess.getoutput("kubectl describe deployment nginx-deployment")
        f.write(describe_output)
    print("Informations de déploiement sauvegardées dans deployment-info.txt")
    
    # Affichage du résultat
    print("\n=== Résumé ===")
    print(subprocess.getoutput("cat deployment-info.txt | grep -E 'Replicas:|Image:'"))

if __name__ == "__main__":
    setup_nginx_scaling()
