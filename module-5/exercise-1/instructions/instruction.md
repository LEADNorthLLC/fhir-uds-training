# Module 5: Exercise 1


# Setting up your environment

**Objective:** This exercise aims to set up your environment for future exercises. 

**Note:** You may need to refer back to these instructions as you start other exercises or if you stop partway through an exercise.  

<need to add something here to make sure they have the latest ISC extensions in VSC>
< need to add something ehre for getting latest repo and unzipping >

The first step is to start your docker container. Open the Docker desktop application. Once that has started, navigate to the **\exercise** folder and run the following command.

	docker-compose up --build -d

This command will take a few moments to run.

Once your container is running you can now access the Healthshare portal at the following url:

	http://localhost:32783/csp/sys/%25CSP.Portal.Home.zen?$NAMESPACE=%25SYS

Now we just need to start the production before we can move forward. Click on **Interoperability** and navigate to the **FHIRDEMO** namespace if not already selected. Click **Configure** then **Production** and finally **Go**.

Inside the Production Configuration screen, you just need to click start and your setup will be complete!

< need to add something here for terminal access >
