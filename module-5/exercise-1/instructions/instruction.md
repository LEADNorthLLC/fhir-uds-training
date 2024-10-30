# Module 5: Exercise 1


# Setting up your environment

**Objective:** This exercise aims to set up your environment for future exercises. 

**Note:** You may need to refer back to these instructions as you start other exercises or if you stop partway through an exercise.  

The first step is to start your docker container. Open the Docker desktop application. Once that has started, navigate to the **\exercise** folder and run the following command.

	docker-compose up --build -d

This command will take a few moments to run.

Once your container is running you can now access the Healthshare portal at the following url:

	http://localhost:32783/csp/sys/%25CSP.Portal.Home.zen?$NAMESPACE=%25SYS

Now we just need to start the production before we can move forward. Click on **Interoperability** and navigate to the **HEALTHTOOLKIT** namespace if not already selected. Click **Configure** then **Production** and finally **Go**.

Inside the Production Configuration screen, you just need to click start and your setup will be complete!

To test if your production is working properly you can access the following url to test the FHIR endpoints:

	http://localhost:32783/swagger-ui/index.html

This url provides preset API requests that you can execute. You can also change the preset data and urls to test the API further.
