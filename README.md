# devops-practical-test

## Follow this steps to run application of Task-1

1. Install nodejs on the system with version-20
2. Now create app.js file and Dockerfile
3. Run below command to initialize npm package and to install dependencies
```
npm init -y && npm install express
```
4. Run this command to build image from Dockerfile --> `docker build -t node-image .`
5. To run container of created image use this command --> `docker run -d -p 3000:3000 --name node-app node-image`
6. Open browser and type `localhost:3000` to see output as a Hello World



## Follow this steps to run application of Task-2

Please note for local system I have used minikube to run kubernetes files

1. Install minikube and start minikube, Once kubenetes node is UP and Running, we can deploy our manifest file.
2. Deploy manifest file using below command 
```
kubectl apply -f k8s-nginx-manifest.yml -n default
```
3. You will see pods getting created. Command to see pods `kubectl get pods`
4. 3 replicas will be created and to check output we can open browser and search with private IP with port number of nodeport defined in manifest file.


## Follow this steps to run application of Task-3

1. Install Ansible as a master node and then edit hosts file located at `/etc/ansible/hosts`
   Add your ec2 user name & server IP like this `ubuntu@65.0.89.164` in webservers section.
2. Add your ssh public key in the remote host of ec2 machine to make connection between Ansible master and node
3. Install & Configure nginx files
```
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```
Update nginx.cong file located at `/etc/nginx` as below. 
```
        server {
            listen 80;
            server_name 65.0.89.164;  # Replace with your domain or instance IP
            location / {
                proxy_pass http://localhost:3000;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
    }
}
```
4. Now run ansible playbook using below command
```
ansible-playbook deploy-playbook.yml
```
This will deploy our nodejs application on our remote ec2 machine.
Open ec2 public IP in the browser 65.0.89.164