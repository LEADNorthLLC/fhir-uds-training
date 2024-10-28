Class FHIRDEMOPKG.FoundationProduction Extends Ens.Production 
{

XData ProductionDefinition
{
<Production Name="FHIRDEMOPKG.FoundationProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="EnsLib.File.PassthroughOperation" Category="Scenario3" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\temp\hl7\outbound\</Setting>
  </Item>
  <Item Name="HS.FHIRServer.Interop.HTTPOperation" Category="Scenario2" ClassName="HS.FHIRServer.Interop.HTTPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">Firely Test Service</Setting>
  </Item>
  <Item Name="HS.FHIRServer.Interop.Operation" Category="Scenario1" ClassName="HS.FHIRServer.Interop.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="Scenario1,Scenario2,Scenario3" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIRServer.Interop.DummyOperation" Category="Scenario3" ClassName="HS.FHIRServer.Interop.DummyOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.HL7.Service.FileService2" Category="Scenario2" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">FHIR.HL7toSDA2</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\temp\hl7\inbound2\</Setting>
  </Item>
  <Item Name="EnsLib.HL7.Service.FileService1" Category="Scenario1" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">FHIR.HL7toSDA1</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\temp\hl7\inbound1\</Setting>
  </Item>
  <Item Name="EnsLib.HL7.Service.FileService3" Category="Scenario3" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">FHIR.HL7toSDA3</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\temp\hl7\inbound3\</Setting>
  </Item>
  <Item Name="FHIR.HL7toSDA1" Category="Scenario1" ClassName="HS.Local.FHIR.HL7toSDAProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process1</Setting>
  </Item>
  <Item Name="FHIR.HL7toSDA2" Category="Scenario2" ClassName="HS.Local.FHIR.HL7toSDAProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process2</Setting>
  </Item>
  <Item Name="FHIR.HL7toSDA3" Category="Scenario3" ClassName="HS.Local.FHIR.HL7toSDAProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process3</Setting>
  </Item>
  <Item Name="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process1" Category="Scenario1" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.Operation</Setting>
    <Setting Target="Host" Name="TransmissionMode">transaction</Setting>
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/fhirdemo/fhir/r4</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process2" Category="Scenario2" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.HTTPOperation</Setting>
    <Setting Target="Host" Name="TransmissionMode">individual</Setting>
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/fhirdemo/fhir/r4</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process3" Category="Scenario3" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.DummyOperation</Setting>
    <Setting Target="Host" Name="TransmissionMode">transaction</Setting>
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/fhirdemo/fhir/r4</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="EnsLib.HL7.Service.FileService4" Category="Scenario4" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">FHIR.HL7toSDA3</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\temp\delimited\inbound\</Setting>
  </Item>
  <Item Name="TransformPatientExportToSDA" Category="Scenario4" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">HS.Local.DTL.UDSPatientExportRule</Setting>
  </Item>
  <Item Name="EnsLib.RecordMap.Service.FileService" Category="Scenario4" ClassName="EnsLib.RecordMap.Service.FileService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\temp\delimited\inbound\</Setting>
    <Setting Target="Host" Name="RecordMap">HS.Local.Messages.UDSPatientExport</Setting>
    <Setting Target="Host" Name="TargetConfigNames">TransformPatientExportToSDA</Setting>
  </Item>
  <Item Name="EnsLib.RecordMap.Service.FileService2" Category="Scenario5" ClassName="EnsLib.RecordMap.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\temp\delimited\inbound5\</Setting>
    <Setting Target="Host" Name="RecordMap">HS.Local.Messages.UDSPatientExport</Setting>
    <Setting Target="Host" Name="TargetConfigNames">PatientExtractToFHIRProcess</Setting>
  </Item>
  <Item Name="PatientExtractToFHIRProcess" Category="Scenario5" ClassName="HS.Local.FHIR.PatientExtractToFHIRProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">FHIROutputToFile5</Setting>
  </Item>
  <Item Name="FHIROutputToFile5" Category="Scenario5" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\temp\delimited\</Setting>
  </Item>
</Production>
}

}
