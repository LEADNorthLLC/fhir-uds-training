Class HS.Local.SDA3.PatientExtension Extends HS.SDA3.DataType
{

Parameter HSDEPLOY = 0;

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Patient";

Property Race As %String;

Property RaceURL As %String(MAXLEN = 256) [ InitialExpression = "http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-race-extension" ];

Property Ethnicity As %String;

Property EthnicityURL As %String(MAXLEN = 256) [ InitialExpression = "http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-ethnicity-extension" ];

Property BirthSex As %String;

Property BirthSexURL As %String(MAXLEN = 256) [ InitialExpression = "http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-birthsex-extension" ];

Property AgeExtension As %String;

Property AgeExtensionURL As %String(MAXLEN = 256) [ InitialExpression = "http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-age-extension" ];

Property GenderIdentityExtension As %String;

Property GenderIdentityExtensionURL As %String(MAXLEN = 256) [ InitialExpression = "http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-gender-identity-extension" ];

Property AgricultureWorkerStatus As %String;

Property AgricultureWorkerStatusURL As %String(MAXLEN = 256) [ InitialExpression = "http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/udsplus-agriculture-worker-status" ];

Property HousingStatus As %String;

Property HousingStatusURL As %String(MAXLEN = 256) [ InitialExpression = "http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-housing-status-extension" ];

Property VeteranStatus As %String;

Property VeteranStatusURL As %String(MAXLEN = 256) [ InitialExpression = "http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-veteran-status-extension" ];



}