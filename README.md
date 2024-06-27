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
