Class HS.Local.FHIR.HL7toSDAProcess Extends (Ens.BusinessProcess, EnsLib.HL7.Util.IOFraming) 
{

/// Patient Id location in message. Format expected: PID:3.1
Property PatientIdLocation As %String [ InitialExpression = "PID:3.1" ];

/// Configuration item(s) to which to send file stream messages
Property TargetConfigNames As %String(MAXLEN = 1000);

/// Store a set of searchable properties associated with each HL7 message processed. <br/>
/// These records will be stored in the named SearchTable class, if any.
Property SearchTableClass As %String(MAXLEN = 128) [ InitialExpression = "EnsLib.HL7.SearchTable" ];

/// For Testing:Override for different schema
Parameter HL7Schema = "2.5.1:ADT_A01";

Parameter NewLine = 10;

Parameter SETTINGS = "PatientIdLocation:Basic,TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

// CNR: Changing signature to Persistent for inheritance trickery -- this may be a crime against humanity

// Method OnRequest(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message) As %Status

Method OnRequest(pRequest As %Persistent, Output pResponse As %Persistent) As %Status
{
        Set tSC = $$$OK  
        Try {

            //Code for pRequest as EnsLib.HL7.Message 
            Set tSeparators = "|^~\&"_$Char(13,10)
            Set inputStream = ##class(%Stream.GlobalCharacter).%New()
            do pRequest.OutputToLibraryStream(.inputStream, tSeparators) 

            do ..GetLocationValue(inputStream, ..PatientIdLocation,.tPatientId) 
 
            //Set the ContentStream to the SDA
			set tSC = ##class(HS.Gateway.HL7.HL7ToSDA3).GetSDA(pRequest,.tSDA)
			set tMessage = ##class(HS.Message.XMLMessage).%New()
			Set tMessage.Name = "HL7_to_SDA"
			Set tMessage.ContentStream = tSDA
			do tMessage.AdditionalInfo.SetAt(tPatientId,"PatientResourceId")
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

/// pLocation can be set as format PID:3 for field Level, PID:3.1 for subfield. 
ClassMethod GetLocationValue(pStream As %Stream.Object, pLocation As %String, ByRef pValue As %String)
{
    
    Set IN1List = ""
    Set pValue = ""

    // Parse location
    Set SegmentId = $PIECE(pLocation, ":", 1)
    Set LocationIndex = $PIECE(pLocation, ":", 2)

    // Handle different numbering in MSH vs other segments
    If SegmentId '= "MSH" {
        Set LocationIndex = LocationIndex + 1
    }

    // Check for subfield specification
    Set SubfieldIndex = ""
    If $LENGTH(LocationIndex, ".") >= 2 {
        Set SubfieldIndex = $PIECE(LocationIndex, ".", 2)
    }
	
    While 'pStream.AtEnd {
        Set line = pStream.ReadLine()

        // Check if the segment matches
        If ($EXTRACT(line, 1, 3) = SegmentId) {
                // Parse the line based on the pipes
                Set FieldList = $LISTFROMSTRING(line, "|")

                // Get the field value
                Set FieldValue = $LISTGET(FieldList, LocationIndex, "")
                //$$$LOGINFO("SegmentId = "_SegmentId)
                //$$$LOGINFO("FieldValue :"_FieldValue)
                // Check for subfield specification
                If SubfieldIndex'="" {
                    // Parse the field based on the carat delimiters
                    Set SubfieldList = $LISTFROMSTRING(FieldValue, "^")
                    Set pValue = $LISTGET(SubfieldList, SubfieldIndex, "")
                } 
                    If SegmentId = "IN1" {
                        	if FieldValue'="" {
                    		Set pValue = FieldValue
                    		}
                            If SubfieldIndex'="" {
                    // Parse the field based on the carat delimiters
                    Set SubfieldList = $LISTFROMSTRING(FieldValue, "^")
                    Set pValue = $LISTGET(SubfieldList, SubfieldIndex, "")
                }
                            If IN1List = "" {
                                set IN1List = $LISTBUILD(pValue)
                            } Else {
                                //Convert existing list to string
                                Set IN1ListString = $LISTTOSTRING(IN1List, ",")
                                If $Find(IN1ListString, pValue) = 0 {
                                //Append list
                                Set IN1ListString = IN1ListString _ "," _ pValue
                                Set pValue = IN1ListString
                                Set IN1List = $LISTFROMSTRING(IN1ListString, ",")
                                }
                            }
                    } ElseIf SubfieldIndex'="" {
                    // Parse the field based on the carat delimiters
                    Set SubfieldList = $LISTFROMSTRING(FieldValue, "^")
                    Set pValue = $LISTGET(SubfieldList, SubfieldIndex, "")
                } Else{
                    // No subfield specified, return the entire field
                    if (FieldValue'="")&&(SegmentId'="IN1") {
                    Set pValue = FieldValue
                    }
                }        
            }
        }
    // Rewind the stream
    Do pStream.Rewind()
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

/****Helper Methods ****/
ClassMethod GetMessage(XDataName As %String) As EnsLib.HL7.Message
{
	#dim SourceMessage as EnsLib.HL7.Message
	set xdata=##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1)_"||"_XDataName,0)
	quit:'$IsObject(xdata) $$$NULLOREF
	set lines=""
	while 'xdata.Data.AtEnd
	{
		set line=$ZSTRIP(xdata.Data.ReadLine(),"<w")
		continue:line=""
		continue:$Extract(line,1)="<" // ignore opening or closing XML tags and start CData tag
		continue:$Extract(line,1)="]" // ignore ]]> closing CDATA
		set lines=lines_($S($L(lines)=0:"",1:$C(..#NewLine)))_line
	}
	set SourceMessage=##class(EnsLib.HL7.Message).ImportFromString(lines,.tSC)
	quit:$$$ISERR(tSC) $$$NULLOREF
	set SourceMessage.DocType=..#HL7Schema
	set tSC=SourceMessage.PokeDocType(..#HL7Schema)
	quit SourceMessage
}

XData SourceMessageA01
{
<test><![CDATA[
MSH|^~\&|Epic|MUSC||BCBSSC|20230911060119|RUBBLE|ADT^A01|249509431|P|2.2
EVN|A01|20230911060119||ADT_EVENT|RUBBLE^MATTHEW^BARNEY^D^^^^^MUSC^^^^^UH|20230911060000|PHL^PHL^ADTEDI
ZVN||LS23450^LS-23450^^^^RTL
PID|1|000163387^^^MRN^MRN|000163387^^^MRN^MRN||MEDINA^CECILIA^||20111102|F||B|100 BEDROCK WAY^^NORTH CHARLESTON^SC^29420-8707^US^P^^CHARLESTON|CHAR|(555)609-0969^P^PH^^^555^6090969~^NET^Internet^ANNAC1@YAHOO.COM~(555)609-0969^P^CP^^^555^6090969||ENG|M|CHR|555443333|260-61-5801|||1|||||Non Veteran|||N
ZPD||MYCH||AC|||N||N
PD1|||MUSC HOLLINGS CANCER CENTER^^10003|1134107873^LINK^MICHAEL^J^^^^^EPIC^^^^PNPI
ROL|1|UP|GENERAL|1134107873^LINK^MICHAEL^J^^^^^EPIC^^^^PNPI|20211115
NK1|1|GABLE^BETTY|PARENT||(555)763-5651^^PH^^^555^7635651||Emergency Contact 1
NK1|2|FLINTSTONE^FRED|Spouse|100 Bedrock way^^REMBERT^SC^29128^US|(888)222-2222^^PH^^^888^2222222|(888)222-3333^^PH^^^888^2223333|Emergency Contact 2
PV1|1|O|R1OR^RTOR^07^RT^R^^^^MUSC RT OR|EL|||1386757342^HALSTEAD^LUCINDA^A.^^^^^EPIC^^^^PNPI|1386757342^HALSTEAD^LUCINDA^A.^^^^^EPIC^^^^PNPI||OTO||||PHYS|||1386757342^HALSTEAD^LUCINDA^A.^^^^^EPIC^^^^PNPI|SO|1197112023|BCBS|||||||||||||||||||||ADMCONF|||20230911060000
PV2||PRV||||||20230911||||HOSP ENC|||||||||N|N||||||||||N
ZPV||||||||||||20230911060000
OBX|1|NM|PRIMARYCSN|1|1197112023||||||F
AL1|1|DA|900525^FISH CONTAINING PRODUCTS^DAM|3|Anaphylaxis|20210823
AL1|2|DA|568^PEANUT^HIC|3|Anaphylaxis|20221209
AL1|3|DA|12753^TREE NUT^HIC|3|Anaphylaxis|20221209
AL1|4|DA|1193^TREE NUTS^DAM|3|Anaphylaxis|20130524
AL1|5|DA|1554^HYDROCODONE^HIC||Other|20210728
AL1|6|DA|3102^POLLEN EXTRACTS^HIC||Other|20201204
AL1|7|DA|11754^SHELLFISH DERIVED^HIC||Other|20210728
DG1|1|I10|Q85.02^Neurofibromatosis, type 2^I10|Neurofibromatosis, type 2||ADMISSION DIAGNOSIS (CODED)
DG1|2|I10|D33.3^Benign neoplasm of cranial nerves^I10|Benign neoplasm of cranial nerves||ADMISSION DIAGNOSIS (CODED)
DG1|3|I10|J38.01^Paralysis of vocal cords and larynx, unilateral^I10|Paralysis of vocal cords and larynx, unilateral||ADMISSION DIAGNOSIS (CODED)
DG1|4||^NF2 (neurofibromatosis 2) [Q85.02]|NF2 (neurofibromatosis 2) [Q85.02]||ADMISSION DIAGNOSIS (TEXT)
DG1|5||^Acoustic neuroma [D33.3]|Acoustic neuroma [D33.3]||ADMISSION DIAGNOSIS (TEXT)
DG1|6||^Unilateral complete paralysis of vocal cord [J38.01]|Unilateral complete paralysis of vocal cord [J38.01]||ADMISSION DIAGNOSIS (TEXT)
GT1|1|780223|FLINTSTONE^ANNA^WILMA^^^^L||100 BEDROCK WAY^^NORTH CHARLESTON^SC^29420-8707^US^^^CHARLESTON|(555)609-0969^P^PH^^^555^6090969~(555)763-5651^P^CP^^^555^7635651||19690812|F|P/F|SL|248-61-5801|||||^^^^^US|||Full
ZG1||||1
IN1|1|BL90^BCBS STANDARD^PLANID||BCBS STATE|ATTN CLAIMS PROCESSING^PO BOX 100605^COLUMBIA^SC^29260-0605||(800)444-4311^^^^^800^4444311|002038404||||20140101||NPR||FLINTSTONE^THOMAS^^V|Sp|19661227|3310 DUBIN RD^^NORTH CHARLESTON^SC^29420^US|||1|||||||||||||1087807|INS0001|||||||M|^^^^^US|||BOTH
IN1|2|BL90^MA-MEMBER^PLANID||BCBS STATE|ATTN CLAIMS PROCESSING^PO BOX 100605^COLUMBIA^SC^29260-0605||(800)444-4311^^^^^800^4444311|002038404||||20140101||NPR||FLINTSTONE^THOMAS^^V|Sp|19661227|3310 DUBIN RD^^NORTH CHARLESTON^SC^29420^US|||1|||||||||||||1087807|CP0091792|||||||M|^^^^^US|||BOTH
IN3|1|||2||20230911|20230911|RUBBLE^MATTHEW^BARNEY^D|||NOT|||||(800)999-0000^^^^^800^9990000~(888)444-5555^^^^^888^4445555
ZIN|||||||FLINTSTONE^THOMAS^^V|||||16871492
]]></test>
}


}
