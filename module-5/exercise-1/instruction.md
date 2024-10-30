# Module 5: Exercise 1


# Setting up your environment

**Objective:** This exercise aims to set up your environment for future exercises. 

**Note:** You may need to refer back to these instructions as you start other exercises or if you stop partway through an exercise.  

To start, please make sure you have the following extensions installed in Visual Studio Code:
	* InterSystems ObjectScript
 	* InterSystems Server Manager
  	* InterSystems Language Server
   	* InterSystems ObjectScript Extension Pack

Download the latest version of this repository (or unzip onto your local machine if provided a zip file).  Open the unzipped folder from Visual Studio Code.  

Next you'll need to build and start your docker container. Make sure your Docker desktop application is running. Once that is confirmed, ensure you don't have any older versions of this code running in Docker.  If so, stop those containers and delete them if not needed.  

Open a terminal prompt from the root folder of the codebase and navigate to the **\iris-container** folder and run the following command.

	docker-compose up --build -d

This command will take a few moments to run.

Once your container is running you can now access the IRIS portal at the following url:

	http://localhost:32783/csp/sys/%25CSP.Portal.Home.zen?$NAMESPACE=%25SYS

Now we just need to start the production before we can move forward. Click on **Interoperability** and navigate to the **FHIRDEMO** namespace if not already selected. Click **Configure** then **Production** and finally **Go**.

Inside the Production Configuration screen, you just need to click start (you'll be adding production components later).

Finally, you'll want to test the ability to access the IRIS terminal of your instance by 

docker exec -it docker-compose-xFormApp-1 iris terminal iris where docker-compose-xFormApp-1 is your container name


< need to add something here for terminal access >
