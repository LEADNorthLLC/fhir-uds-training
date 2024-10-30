Class HS.Local.FHIR.DTL.SDA3.vR4.Patient.AgeExtension Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Patient, HS.FHIR.DTL.vR4.Model.Base.Extension) ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 0;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Patient' targetClass='HS.FHIR.DTL.vR4.Model.Base.Extension' create='existing' language='objectscript' >
<annotation> Transforms HS.SDA3.Patient (SDA3) to Age Extension (vR4) </annotation>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.Age).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source, "HS.Local.FHIR.DTL.SDA3.vR4.Patient.AgeExtension")' property='DTL' action='set' />
<if condition='DTL&apos;=""' >
<true>
<assign value='$classmethod(DTL, "Transform", source, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""' >
<true>
<assign value='"http://fhir.org/guides/hrsa/uds-plus/StructureDefinition/uds-plus-age-extension"' property='target.extension.(1).url' action='set' >
<annotation> Value of extension </annotation>
</assign>
<assign value='70' property='target.extension.(1).valueQuantity.value' action='set' />
<assign value='"yr"' property='target.extension.(1).valueQuantity.unit' action='set' />
<assign value='"http://unitsofmeasure.org"' property='target.extension.(1).valueQuantity.system' action='set' />
<assign value='"a"' property='target.extension.(1).valueQuantity.code' action='set' />
</true>
</if>
</true>
</if>
</transform>
}

}
