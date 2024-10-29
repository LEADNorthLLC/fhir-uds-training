# Module 7 Exercise 1 - Mapping Custom File Data to SDA #

**Learning Objectives:** 
* Build an end-to-end pipe-delimited data to FHIR pipeline
* Set the configuration to individual resources instead of bundles
* Read a FHIR message trace
* Validate a FHIR Resource using the FHIR Vaildator

**Task:** In this exercise, you will take a sample batch file in pipe-delimited format and transform it directly to SDA format which will then be transformed to a FHIR Patient Resource.

## Instructions:

### Task 1: Build the Record Map 
The sample file is pipe-delimited (|) and contains a batch of patient records. 


1. Create a new folder in the project at `iris-container/data/durable/` named `module7-exercise1-inbound`. 
2. Locate the sample file located in `iris-container/data/samples/UDS_patient_export_sample.txt`. Copy the file and paste it into the new folder created in Step 1. (This is necessary because the IRIS instance can only "see" files that are in the container environment. The `/data/durable` folder is mounted so it is visible from both the external and in-container environment) 
3.	**Open the Record Mapper Utility:** From the Home page of the Management Portal, go to **Interoperability -> Build -> CSV Record Wizard**. 

4. **Fill out the form with the following values:** 
First select the `UDS_patient_export_sample.txt` file by navigating `/irisdata/module7-exercise1-inbound`. You will have to change the filter to “All files”. 
* RecordMap name: UDSPatientExport
* Separator: |  (found on right side, SHIFT-backslash key)
* Record Terminator: CRLF
* Character Encoding: UTF-8
* Sample has header row: checked
* Click **Create RecordMap**
 
•	This generates the record map class based on the data: 
 

•	This screen can be used to edit the data type of the fields and add annotations for documentation as well deal with more complex formats with repeating structures, but for this exercise, you will deal with everything just as Strings and keep things flat. 

3.	Now that you have the source format built, you will need to determine where the fields need to be mapped in the SDA in order to map to the relevant location in the FHIR resource. 
Use the FHIR Annotations lookup from t exercise to fill out the mapping table. Whenever you find a field that doesn’t have a direct mapping to the current SDA or FHIR R4/USCDI Resource, make a note about it. We will figure out how to handle those in the exercise after this one.  

Source Field	SDA Location	FHIR R4/USCDI Resource 	Notes
Id			
Race			
Ethnicity			
BirthSex			
BirthDate			
GenderIdentity			
AgricultureStatus			
HousingStatus			
VeteranStatus			
Deceased			

4.	You will now create a DTL to map from the delimited file to the SDA format. Don’t worry about the missing fields, you’ll only map the ones that are there for now. 
•	Open the DTL Editor. Interoperability -> Build -> Data Transformations. 
•	Select New. 
o	
•	 

•	Fill out the Data Transformation Wizard:
Package: HS.Local.FHIR.DTL.


 
3. **Open the FHIRDEMO Production:** Navigate to the production by selecting **HOME->Interoperability**. You will see **FHIRDEMO** in the list of namespaces. Select **FHIRDEMO** and then in the next screen, click the **Go** button to view the production. 

4. **Add a Business Service:** Click on the plus `+` next to the **Services** header. 

Configure these **Business Service** settings in the wizard: 

| **Configuration Name**  | **Value** |
|:-----------------------:|:---------:|
| Service Class | EnsLib.HL7.Service.FileService |
| Service Name | HL7InboundFileService1 |
| Display Category | Module6-Exercise1 |
| Enable Now | Selected |

![Configure HSDEMO](../images/module6-1-add-hl7-service.png)

The service should be added to the production now. 

6. **Add a Business Process:** Click on the `+` symbol next to the **Processes** header. 

Configure these **Business Process** settings in the wizard: 

| **Configuration Name**  | **Value** |
|:-----------------------:|:---------:|
| Business Process Class | HS.Local.FHIR.HL7toSDAProcess |
| Business Process Name | FHIR.HL7toSDA1 |
| Display Category | Module6-Exercise1 |
| Enable Now | Selected |

7. **Add the Standard FHIR Business Process:** Click on the `+` symbol next to the **Processes** header. (We will have two business prcesses).

Configure these **Business Process** settings in the wizard: 

| **Configuration Name**  | **Value** |
|:-----------------------:|:---------:|
| Business Process Class | HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process |
| Business Process Name | HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process1 |
| Display Category | Module6-Exercise1 |
| Enable Now | Selected |

8. **Add a Standard FHIR Server Operation:** Click on the `+` symbol next to the **Operations** header. 

Configure these **Business Operation** settings in the wizard: 

| **Configuration Name**  | **Value** |
|:-----------------------:|:---------:|
| Operation Class | HS.FHIRServer.Interop.Operation |
| Operation Name | HS.FHIRServer.Interop.Operation |
| Display Category | Module6-Exercise1 |
| Enable Now | Selected |

9. **Build End-to-End**: Now you have four business components. In order to hook them together to run and end-to-end, we'll cover the **Properties** for each of the components. 

*9-1*. Start on the left by clicking on the icon/name for the **HL7InboundFileService1** service: 

Then click on the **Settings** tab on the right panel to configure the service properties: 

| **Property Name**  | **Value** |
|:-----------------------:|:---------:|
| File Path | /irisdata/module6-exercise1-inbound/ |
| TargetConfigNames | FHIR.HL7toSDA1 |

Make sure to click **Apply** to save your Settings. 

*9-2*. Click on the icon/name for the **FHIR.HL7toSDA1** Process. 

This is a custom process that is identifying what HL7 field will be set as the `PatientResourceId`, which is required in the Patient Resource. Configure the following Settings.   

| **Property Name**  | **Value** |
|:-----------------------:|:---------:|
| PatientIdLocation | PID:3.1 |
| TargetConfigNames | HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process1 |

Make sure to click **Apply** to save your Settings. 

*9-3*. Click on the icon/name for the **HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process1** Process. 

Configure the following Settings.   

| **Property Name**  | **Value** |
|:-----------------------:|:---------:|
| TargetConfigNames | HS.FHIRServer.Interop.Operation |
| TransmissionMode | transaction |
| FHIRMetadataSet | HL7v40 / FHIR R4 Core Specification |
| FHIREndpoint* | /csp/healthshare/fhirdemo/fhir/r4 |
| LogTraceEvents | *checked* |
| TraceOperations | `*FULL*` |

* The **FHIREndpoint** path doesn't yet exist, but you will configure this in a few steps. 

Make sure to click **Apply** to save your Settings. 

*9-4*. Click on the icon/name for the **HS.FHIRServer.Interop.Operation** Operation. 

Configure the following Settings.   

| **Property Name**  | **Value** |
|:-----------------------:|:---------:|
| TransmissionMode | transaction |
| FHIRMetadataSet | HL7v40 / FHIR R4 Core Specification |
| FHIREndpoint* | /csp/healthshare/fhirdemo/fhir/r4 |
| LogTraceEvents | *checked* |
| TraceOperations | `*FULL*` |

Make sure to click **Apply** to save your Settings. 

10. **Add the Trace Logging Operation** 

Click on the `+` on the Operations header to the right and add `HS.Util.Trace.Operations` as the Class name and Operation name. Select `Enable` and **Apply**. 

11. **Configure the FHIR Server**

With the **FHIRDEMO** namespace selected, click on **Home** and then select **HEALTH** either on the panel on the left or at the top of the System Management portal. 

Select the **FHIR Configuration** section: 

![FHIR Server Configuration](../images/module6-1-fhirserver-config.png)

*11-1*. Log in with the same username and password for IRIS. User:`_system` Password: `SYS`

*11-2*. Select **Server Configuration** and then click the **Add Endpoint** button. 

Enter these configurations: 
Configure the following Settings.   

| **Property Name**  | **Value** |
|:-----------------------:|:---------:|
| CORE FHIR package | hl7.fhir.r4.core@4.0.1 |
| URL | /csp/healthshare/fhirdemo/fhir/r4 |
| Additional packages | hl7.fhir.us.core@3.1.0 |
| Interactions Strategy Class | HS.FHIRServer.Storage.Json.Interactions.Strategy |
| Storage | *Keep all default values* |

Click **Add**. It will take a few minutes to build the endpoint. You can leave this screen and return to VSCode while the endpoint builds. 

12. **Create the data iput directory in VS Code**

Typically, the file system in the Docker container is completely separate from the folders and files you have in the project folder. However, the container has been set up with a bind mount that connects the `iris-container/data/durable` folder in the FHIR-UDS-TRAINING project with the `/irisdata` folder in the IRIS instance. 

*12-1*. In VSCode, right click on the `iris-continer/data/durable` folder and select `Add Folder`. Name the folder `module6-exercise1-inbound` in order to match what you configured in the Business Service Settings in the IRIS production. 

Your folders will look like this (Don't worry if the top-level name is more detailed than `FHIR-UDS-TRAINING`): 

![Set Up Inbound Data Folder](../images/module6-1-inbound-data-folder.png)

*12-2*. Open the `samples` folder. Right click on the `ADT_A01JohnDoe.hl7` file and select `Copy`. 

*12-3*. Click on the `module6-exercise1-inbound` folder. Right click and select `Paste`. 

You will see the file copied into the directory and then it may disappear. This is good news. The inbound file service running in IRIS has picked it up and attempted to process it. 

13. **Check the Production:** Return to your System Management Portal. If you are looking at the "FHIR Server" screen, you can click on the profile for the `_system` user in the right corner. Once you click on the icon, select **Management Portal** to retrn **Home**.  

Go to **Home -> Interoperability -> Select FHIRDEMO -> Configuration -> Production**. 

Click on the **Messages** tab. You should see the available message traces. Click on the link under **Header** to trace the activity. 

If you see errors, read the error messages, doouble check settings, and try to fix things so you get a complete message trace (see below). If you ever need to re-run the message, you can re-send from the **Message Viewer** or drop the file again like you did in **Step 14**.

14. **Review the Message Trace:**

If everything has gone well, Step 5 of the trace will show the actual FHIR bundle that was sent to the local FHIR Server. 

![FHIR Message Trace](../images/module6-1-message-trace.png)

15. Review the steps in the message trace. Can you confirm whether or not the FHIR bundle posted successfully? What was the response status code from the FHIR Server? 

16. You turned on `*FULL*` Trace so you could see detailed information like the actual FHIR bundle. 

> This is a good technique for testing, but should be turned off once the interface is in production as FHIR bundles can get very big.

Click on Step 5 and on `View Raw =Contents`. Copy the JSON string in the **<ItemValue>** tags, but do not include the tag. 

17. Go to the FHIR validator at [FHIR Validator](https://validator.fhir.org). 

*17-1*. Select the **Options** menu at the top. Then select the **FHIR Version (4.0.1)** and **Implementation Guides (hl7.fhir.us.core version 3.1.0)** and select **Add**.

This is the version of the FHIR Server we are checking against (remember when we configured those packages on the endpoint?)

![Configure FHIR Validator](../images/module6-1-fhir-validator.png)

*17-2*. Click back on **Validate** and paste the JSON into the **Enter Resource** window. 

Select the **Validate** button at the bottom of the screen and review the errors and warnings. 

18. Even though the FHIR bundle was accepted by the IRIS FHIR Server, there are many errors still when the message is validated against the official specifications. FHIR Servers will vary in how strict their validations are and whether they are configured to reject messages or accept them when there are non-conformance issues that are not deemed fatal. 

19. Now that you have completed an end-to-end, go back to the **FHIRDEMO** and try to figure out how to do each of these: 

*19-1*. What happens when you send another HL7 message through? What about an ORU? 

*19-2*. How can you configure the components to send indivudal resources rather than an entire bundle at once? 

*19-3*. How can you configure the feed to use the **Message Control ID (MSH:10)** as the `PatientResourceId`? (You wouldn't necessarily want to do this, but it is good to see how the message changes when that's done)

*19-4*. **Bonus!!!** Can you figure out how to use Postman to query back the message you just sent in? 

> DO NOT do a ***COMPOSE RESTART*** on the container. This will rebuild the container and you will lose all changes unless you have saved them first. 

## To Save the Production: 

You can copy the contents of the **FHIRDEMO.FoundationProduction** class to the **FHIR-UDS-TRAINING/src/FHIRDEMOPKG** folder via Cache Studio or Visual Studio Code.  

> Tip: You can keep the Docker service > running in the background while you work. If you want to shut it down, select **Compose - Down**. When you want to restart it, select **Compose - Up**. It will start up much faster than when you select **Compose - Restart** however all your coding and configuration changes will be reset. 

> Solution: There is a completed production class saved in the [Module 6 Solutions Folder](../solutions/exercise-1/FHIRDEMO.FoundationProduction.cls). This contains the production configuration, but does not contain the FHIR Server configuration. 
