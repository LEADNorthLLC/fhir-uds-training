# Module 6 Exercise 2 - Creating a Custom DTL #

**Learning Objective:** 
* Identify the location of standard DTLs
* Create custom DTLs for mapping FHIR resources
* Create sub-transform DTL for mapping UDS age extension
* Validate FHIR bundle against UDS definitions

**Reference:** [SDA to FHIR Transformation Product Documentation](https://docs.intersystems.com/irisforhealthlatest/csp/docbook/DocBook.UI.Page.cls?KEY=HXFHIR_transforms)

**Task:** The UDS Profile for the Patient Resource contains extensions that are unique to UDS. In this exercise, you will be customizing the Patient Resource transformation in order to include the UDS Plus Age Extension. The output format should look like the following sample:

```bash
{
      "url" : "http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-age-extension",
      "valueQuantity" : {
        "value" : 70,
        "unit" : "yr",
        "system" : "http://unitsofmeasure.org",
        "code" : "a"
}
    
```

**Requirements:**
Calculate the age *value* by taking the current year and subtracting the year sent in the **source.birthTime** field in the SDA. You will hardcode the other values in the extension.  

## Setting up Custom Transformation
First set the location of the custom DTL library

1. Open the InterSystems Terminal from VS Code. First make sure the Docker container is running. Open a Terminal by going to **View Menu -> Terminal**

2. This opens the Terminal window at the bottom of the project. (It may already be open). 
* Find the `+` sign with the pull down. 
* Select `Git Bash` as the terminal type. 
* Type `docker ps` to figure out the name of the container. In this case `iris-container-1`
* Once you have the name, type this command to start the shell. You will be looking at the internal Docker file system: 

```bash
	docker exec -it **iris container name** bash
```
* From the new command prompt, open IRIS terminal by typing: `iris session IRIS`
* Log in with the `_system/SYS` user/password

Here is a screenshot showing the commands: 
![Terminal commands](../images/module6-2-open-iris-terminal.png)

3. Change to **FHIRDEMO** namespace:

```bash
	set $namespace = "FHIRDEMO"
```

4. To check if a custom DTL package already exists, enter:

```bash
 	Write ##class(HS.FHIR.DTL.Util.API.ExecDefinition).GetCustomDTLPackage()
```

5. If the custom DTL package does not already exist, enter the following command which designates **HS.Local.FHIR.DTL** as the name of your custom DTL package:
```bash
 	set status = ##class(HS.FHIR.DTL.Util.API.ExecDefinition).SetCustomDTLPackage("HS.Local.FHIR.DTL")
```

6. To check that the package was defined successfully, enter:

```bash
 write status
```

The response should be: 1 which means the process was successful. You have set your custom DTL package. The FHIR processes will automatically give precedence to any versions of the DTL transforms located **HS.Local** in the **FHIRDEMO** namespace. 

## Modifying the DTL Transformation Code

1. Open up the Patient Resource DTL: **HS.FHIR.DTL.SDA3.vR4.Patient.Patient**

2. Click on **Save As** to copy the **HS.FHIR.DTL.SDA3.vR4.Patient.Patient** class to a new class called: **HS.Local.FHIR.DTL.SDA3.vR4.Patient.Patient**. The naming is important here as the FHIR base code will give this custom class precedence over the out-of-the-box transform. 

![Save Local Patient Resource DTL](../images/module6-2-save-resource-as.png)

3. Create a Sub-transform to do the work of mapping the extension. 

From the Data Transformation Builder, open **HS.FHIR.DTL.SDA3.vR4.Address.Extension** as a model of an extension mapping. 

*3-1*. Save As: **HS.Local.FHIR.DTL.SDA3.vR4.Patient.AgeExtension**

The location of this is not as sensitive as the code you write will reference this class directly. 

*3-2*. Click on the **Transform** tab and update the following settings: 

| **Setting Name**  | **Value** |
|:-----------------------:|:---------:|
| Source Class | HS.SDA3.Patient |
| Target Class | HS.FHIR.DTL.vR4.Model.Base.Extension |

![Save As Age Extension DTL](../images/module6-2-custom-extensionDTL.png)

4. Following the existing code in the DTL as a model, modify the values to follow the same pattern, but map out the **UDS Plus Age Extension** as detailed in the **Task** section above. 

**Example:** This image shows an example with the age (target.extension(1).valueQuanity.value) hard-coded rather than calculated. You can do that as a first step. 

![Code added in Age Extension DTL](../images/module6-2-age-extension-code.png)

Save and Compile when done. 

5. Open the Transformation for **HS.Local.FHIR.DTL.SDA3.vR4.Patient.Patient**

> Be very careful when editing this code. You are keeping the Patient Resource mapping intact while adding in a call-out to the sub-transform for the Age Extension you just created. 

Follow the model in the existing class to call the sub-transform. In the example, the code block was added rigt before the **birthTime** mapping since the **source.birthTime** value is used to caculate the age. 

![Code block added in Patient Resource DTL](../images/module6-2-custom-patient-DTL.png)

Save and Compile When done. 

## Test The Changes
*No changes to the existing Production are needed for the local DTL code changes to take effect*

1. Repeat the steps you did in **Module 6 - Exercise 1** to drop an HL7 message in **iris-container/data/durable/module6-exercise1-inbound**. 
2. Check in the **Message Trace** to ensure there were no errors. Review the output FHIR bundle or transaction to confirm that the update took effect. 
3. Troubleshoot the mapping as needed. 

## FHIR Validation
1. Go to the FHIR validator at [FHIR Validator](https://validator.fhir.org). 

*1-1*. Select the **Options** menu at the top. Then select the **FHIR Version (4.0.1)** and **Implementation Guides (hl7.fhir.us.core version 3.1.0)** and select **Add**.

*1-2*. Search for `uds` in the Implementation Guides. Select **fhir.hrsa.uds-plus** and select the **current** version. Click **Add**. 

Now you are validating against the UDS+ IG as well! Isn't FHIR fun? 

![FHIR Validator with UDS](../images/module6-2-validation-uds.png)

2. Click back on **Validate** and paste the updated JSON into the **Enter Resource** window. 

3. Select the **Validate** button at the bottom of the screen and review the errors and warnings. 

4. Search through the errors. You should find a few that are specific to the `uds-plus-age-extension`. 

![UDS Age Extension Error](../images/module6-2-uds-age-error.png)

5. To experiment, you can update the uds age extension directly in the window and validate again. This is an easy way to see what the correct mapping is supposed to be. 

**Summary:** We muscled in a change just to see it take effect and start the testing and validation cycle. There's work ahead to complete the full mapping and make sure it conforms, but hopefully this exercise has given you a good idea of how to accomplish this task using the tools available.  

> DO NOT do a ***COMPOSE RESTART*** on the container. This will rebuild the container and you will lose all changes unless you have saved them first. 

## To Save the Production: 

You can copy the contents of the **HS.Local.FHIR.DTL.SDA3.vR4.Patient.Patient** and the **HS.Local.FHIR.DTL.SDA3.vR4.Patient.AgeExtension** class to the **FHIR-UDS-TRAINING/src/FHIRDEMO** folder via Cache Studio or Visual Studio Code.  

> Tip: You can keep the Docker service > running in the background while you work. If you want to shut it down, select **Compose - Down**. When you want to restart it, select **Compose - Up**. It will start up much faster than when you select **Compose - Restart** however all your coding and configuration changes will be reset. 

> Solution: There is a completed production class saved in the [Module 6 Solutions Folder](../solutions/exercise-2). This contains the production configuration, but does not contain the FHIR Server configuration.