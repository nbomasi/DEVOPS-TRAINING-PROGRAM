# MERN STACK IMPLEMENTATION

1. **BACKEND CONFIGURATION**

   Installing Node.js
   Command: sudo apt update ; sudo apt upgrade ; curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - ; sudo apt-get install -y nodejs ; mkdir Todo ; npm init_
![Nodejs installed](https://user-images.githubusercontent.com/65962095/171427181-178d9c7a-58f1-4416-a18e-ee4c836afd89.PNG)

   
1a. **INSTALL EXPRESSJS**
Command: npm install express ; touch index.js ; npm install dotenv ; node index.js
![Expressjs installed](https://user-images.githubusercontent.com/65962095/171431963-c5ec62dd-586b-43a9-b959-5f659f5c1e3b.PNG)

1b. **ROUTES DIRECTORY**
Command: mkdir routes ; touch api.js 

1c. **MODELS**
Command: npm install mongoose ; mkdir models ; touch todo.js ; vim todo.js ; vim api.js

1d. **MONGODB DATABASE**
MLab Mongo account created successfully
Command: touch .env ; DB = mongodb+srv://bomasi:%40Eee068037@cluster0.ndjq1.mongodb.net/?retryWrites=true&w=majority ; vim index.js
![MongoDB connection](https://user-images.githubusercontent.com/65962095/171457303-0eb74776-b157-40f1-ba14-f711db33fd9e.PNG)
![Postrequest](https://user-images.githubusercontent.com/65962095/171457620-60625ff1-aeb3-4d09-937a-bdba0c7a98f3.PNG)
![GET request](https://user-images.githubusercontent.com/65962095/171610956-e721a18d-a29f-4878-b15e-50111b454cee.PNG)

2. **FRONTEND IMPLEMENTATION**

2a. **Running React Components**
Command: _npx create-react-app client ; npm install concurrently --save-dev_ ; After the command the file package.json was edited ; _npm run dev_

2b. **Creating React Component**
Command: cd src ; mkdir components ; touch Input.js ListTodo.js Todo.js ; vi Input.js ; npm install axios ; cd src/components ; vi ListTodo.js ; vi Todo.js ; vi App.js 
         ; vi ListTodo.js ; vim index.css ; npm run dev
![Todo page Terminal](https://user-images.githubusercontent.com/65962095/171744650-f6478e76-e127-42ba-9787-f67d9a994ce8.PNG)
![Todo page](https://user-images.githubusercontent.com/65962095/171744656-bef34404-6aac-494a-a7b4-30514889c4f4.PNG)

 




