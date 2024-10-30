Class FHIRDEMOPKG.FoundationProduction Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="FHIRDEMOPKG.FoundationProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="HS.FHIRServer.Interop.Operation" Category="Module6-Exercise1" ClassName="HS.FHIRServer.Interop.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="Module6-Exercise1" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.HL7.Service.FileService1" Category="Module6-Exercise1" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">FHIR.HL7toSDA1</Setting>
    <Setting Target="Adapter" Name="FilePath">/irisdata/module6-exercise1-inbound</Setting>
  </Item>
  <Item Name="FHIR.HL7toSDA1" Category="Module6-Exercise1" ClassName="HS.Local.FHIR.HL7toSDAProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process1</Setting>
  </Item>
  <Item Name="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process1" Category="Module6-Exercise1" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.Operation</Setting>
    <Setting Target="Host" Name="TransmissionMode">transaction</Setting>
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/fhirdemo/fhir/r4</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
<Item Name="UDSFHIRServer.Operation" Category="Module7-Exercise1" ClassName="HS.FHIRServer.Interop.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="UDSPatientExportFileService" Category="Module7-Exercise1" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">FHIR.RecordMappertoSDA</Setting>
    <Setting Target="Adapter" Name="FilePath">/irisdata/module7-exercise1-inbound</Setting>
  </Item>
  <Item Name="FHIR.HL7toSDA1" Category="Module7-Exercise1" ClassName="HS.Local.FHIR.HL7toSDAProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process1</Setting>
  </Item>
  <Item Name="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process2" Category="Module7-Exercise1" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.Operation</Setting>
    <Setting Target="Host" Name="TransmissionMode">transaction</Setting>
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/fhirdemo/fhir/uds</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
</Production>
}

}
