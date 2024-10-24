# Exercise 3


# Transforming HL7 to SDA

***To start this exercise you must have previously completed Exercise 5 and have the production running.***

**Objective: **Learn how to use FHIR endpoints to create FHIR HL7 transformations. 

In this exercise we will be using swagger for our exercises. *Please note that you do not have to use swagger in the future. Any way of accessing API’s will work, IE testing applications like Postman, eclipse, ect.*

	*http://localhost:32783/swagger-ui/index.html*

The endpoint we will be using in this exercise takes in an HL7 message and then returns SDA 

Tasks:



1. Transform to SDA
2. Transform to SDA
3. Bonus: Try to send one or both of the previous messages to the FHIR endpoint using a service other than swagger.

Now that you have a sense of how to use the service let’s break down the process so you can set it up in future projects.

We start with a web application. 

Inside of the code repo you have been given you can check what that web application is actually doing. The service is in the following file: 

	*src\HealthToolKit\REST\HL7.cls*

Take a moment to try to break down and understand what is going on inside of the hl7 method then come back here.

This method is surprisingly simple. It is just passing the HL7 message into the production, which thankfully should be more familiar territory for us. Let’s now follow the HL7 message further along.

Navigate to production.

This production is set up to handle CDA and HL7, but we just want to focus on HL7 for now. We enter in our service, HLK7_Http_Service. This entry point only passes the message into the processes since the web application is taking care of the actual entry point. Please note that your entryway does not have to be an API. Any typical service can work for you. From there we are passed forward to the HL7_SDA business process. 

Let’s practice locating files in a docker container. Look at the class name in HL7_SDA under Informational Settings and use the trace to find the file. If you have trouble compare the file you previously found’s classname to its location.

Now that we are in the file, let’s look at the OnRequest method. Just like our API this is a fairly simple method. It turns our HL7 message to SDA using Healthshare default classes on line 19. It then sends that SDA to the next process in the chain.

Go back to your production and use the same process you used to find HL7_SDA’s file to open the file it is going to next.

You will immediately notice that this file is quite a bit more complex than the others we have seen so far. This file is where the “magic” happens. 

The process starts like every other process in the OnRequest method, but unlike HL7_SDA where this method was handling everything, OnRequest in here is just doing some prep work. It is standardizing the data for the method that is doing the bulk of the work, ProcessSDARequest. Take a moment and read through this method. 