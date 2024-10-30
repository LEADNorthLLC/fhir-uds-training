# Module 5: Exercise 2


# Loading and Navigating SDA

***To start this exercise you must first complete Module 5 Exercise 1.***

**Objective:** The goal of this exercise is to learn about InterSystems SDA.

First, navigate to the XML Schemas screen of your IRIS instance. You can do this by clicking the following link:

	http://localhost:32783/csp/healthshare/fhirdemo/EnsPortal.EDI.XML.SchemaMain.zen?$NAMESPACE=FHIRDEMO&$NAMESPACE=FHIRDEMO&

Now, click on the Import button and select the HS.SDA3.xsd file located under the \irisdata\ folder. If you don't see the file, ensure that your "File of Type" dropdown is set to see XSD files. Complete the import.

Now you should see all of the sections/structures contained within the SDA XML format. Any documentation you may run across that relates to "Viewer cache or VIEWERLIB" can generally be ignored as this relates to Clinical Viewer in a HealthShare UCR environment only.

**Tasks:**
1. Search for and open the link for Container. How is this similar and different from a FHIR bundle?
2. Click on the Procedures() on Row 15.  Review the details for ProcedureTime and indicate below what HL7 field this data comes from.

3. Scroll to the EncounterNumber field on Row 4.  What happens when PV1-19.1 is null?

   
4. What is the EncounterNumber when PV1-19.1 is populated and FromTime is also populated?

   
5. Head back to the main page for Container and indicate which section of SDA will contain the data coming in from DG1?

   
6. Go another level up to the main SDA schema page and dig into three more SDA structures. Scan the documentation to get a feel for some of the constraints, data types and other details that involve mapping data into SDA3.

