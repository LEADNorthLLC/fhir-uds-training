Class HS.Local.FHIR.RecordMappertoSDAProcess Extends (Ens.BusinessProcess, EnsLib.HL7.Util.IOFraming) [ ClassType = persistent ]
{

/// Patient Id location in message. The Property name in the record mapper generaed class. Format expected: Id
Property PatientIdLocation As %String [ InitialExpression = "Id" ];

/// DTL Transformation Class - The name of the class that contains the Record Mapper to SDA conversion logic
Property DTLTransformationClass As %String(MAXLEN = 50) [ InitialExpression = "HS.Local.FHIR.DTL.UDSPatientExportToSDA" ];

/// Configuration item(s) to which to send file stream meDssages
Property TargetConfigNames As %String(MAXLEN = 1000);

Parameter SETTINGS = "PatientIdLocation:Basic,DTLTransformationClass:Basic,TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

// CNR: Changing signature to Persistent for inheritance trickery -- this may be a crime against humanity

// Method OnRequest(pRequest As HS.Local.Messages.UDSPatientExport.Record, Output pResponse As HS.Message.XMLMessage) As %Status

Method OnRequest(pRequest As %Persistent, Output pResponse As %Persistent) As %Status
{
        Set tSC = $$$OK  
        Try {

            //Code for pRequest as HS.Local.Messages.UDSPatientExport.Record
            
           	
           	set tSDAResult = ##class(EnsLib.EDI.XML.Document).%New()
 			//Invoke a DTL to convert the RecordMapper Record to SDA based on Property: DTLTransformationClass
 			//Set tSC = $CLASSMETHOD("HS.Local.FHIR.DTL.UDSPatientExportToSDA", "Transform", pRequest, .tSDAResult, .aux)
			Set tSC = $CLASSMETHOD(..DTLTransformationClass, "Transform", pRequest, .tSDAResult, .aux)
			
			
 			//set tSC=##class(HS.Local.FHIR.DTL.UDSPatientExportToSDA).Transform(pRequest,tResponse, .aux)
 			set tSDAStream = ##class(%Stream.TmpCharacter).%New()
 			//Convert tSDAResult which is of type EnsLib.EDI.XML.Document
 			set tSC = tSDAResult.OutputToLibraryStream(.tSDAStream)
 			
 			
 			
            //Set the ContentStream to the SDA
			set tMessage = ##class(HS.Message.XMLMessage).%New()
			Set tMessage.Name = "RecordMapper_to_SDA"
			Set tMessage.ContentStream = tSDAStream
			
			//CNR: figure out how to set this next
			do tMessage.AdditionalInfo.SetAt(pRequest.Id,"PatientResourceId")
        	set tSC = ..SendRequestSync(..TargetConfigNames,tMessage,.pResponse)
			
        }
        Catch ex {
            // Handle any exceptions here
            Set tSC = ex.AsStatus()
		    $$$LOGERROR(tSC)
        }
        
        Quit tSC
}

Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, callresponse As %Library.Persistent, pCompletionKey As %String) As %Status
{
	//handle async response
	Quit $$$OK
}

ClassMethod FormatDate(pDate As %String, pFormat As %String = "YYYY-MM-DD") As %String
{
    Set resultDate = ""
    if $LENGTH(pDate) >= 8 {
        Set resultDate = $EXTRACT(pDate,1,4)_"-"_$EXTRACT(pDate,5,6)_"-"_$EXTRACT(pDate,7,8)
    }
    Quit resultDate
}

// Unit Test to send a positive case through

/*
ClassMethod Test(tMessage As %String = "") As %Status [ Internal ]
{
	#dim tSC 			As %Status=$$$OK
	#dim eException  	As %Exception.AbstractException
    #dim tRequest as EnsLib.HL7.Message
    set processName = "FHIR.HL7ToSDA"

	Try {
        #;First we grab a previous request using the message body ID from the message viewer/visual trace
        Set tRequest=##class(EnsLib.HL7.Message).%New()
        If tMessage '= ""{
            Set tRequest=##class(EnsLib.HL7.Message).%OpenId(tMessage)
        }
        Else{

            // Load HL7Message per UnitTest
	        set HL7Message=..GetMessage("SourceMessageA01")
	        if '$IsObject(HL7Message) {
                Throw $$$ERROR(5001,"Failed to correlate Xdata for Source Message")
            }
    	    set tRequest=HL7Message.%ConstructClone(1)
        }
      
        // Next we create an instance of the Process.  GetShadowInstance will return the live instance if the production is running otherwise a static but populated instance
        Set tProcess=##class(Ens.Host).GetShadowInstance(processName)
        Do tProcess.OnInit()

        //Since the business item is a process, the method to call is always OnRequest
        Set tSC = tProcess.OnRequest(tRequest,.tResponse)
  	}
	Catch eException {
		Set tSC=eException.AsStatus()
	}
	Quit tSC
}
*/

/****Helper Methods ****/
XData SourceMessageA0
{
<test></test>
}

Storage Default
{
<Data name="RecordMappertoSDAProcessDefaultData">
<Subscript>"RecordMappertoSDAProcess"</Subscript>
<Value name="1">
<Value>Framing</Value>
</Value>
<Value name="2">
<Value>DefCharEncoding</Value>
</Value>
<Value name="3">
<Value>%outFraming</Value>
</Value>
<Value name="4">
<Value>PatientIdLocation</Value>
</Value>
<Value name="5">
<Value>TargetConfigNames</Value>
</Value>
<Value name="6">
<Value>DTLTransformationClass</Value>
</Value>
</Data>
<DefaultData>RecordMappertoSDAProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
