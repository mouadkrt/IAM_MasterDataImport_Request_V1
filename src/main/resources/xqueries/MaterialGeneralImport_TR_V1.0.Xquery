xquery version "1.0";
(:: pragma bea:global-element-parameter parameter="$webServiceEventLauncherRequest1" element="ns1:WebServiceEventLauncherRequest" location="../WSDLs/WebServiceEventLauncher.wsdl" ::)
(:: pragma bea:global-element-return element="ns0:MaterialGeneralImport" location="../WSDLs/MaterialGeneralImport_V1.wsdl" ::)

declare namespace ns1 = "urn:Ariba:Buyer:vsap";
declare namespace ns0 = "urn:iwaysoftware:ibse:jul2003:MaterialGeneralImport";
declare namespace xf = "http://tempuri.org/MasterDataImport_Request_V1/transformations/MaterialGeneralImport_TR_V1.0/";

declare function xf:MaterialGeneralImport_TR_V1($webServiceEventLauncherRequest1 as document-node())
    as element(ns0:MaterialGeneralImport) {
        <ns0:MaterialGeneralImport>
            <ns0:ZARIBA_MATERIAL_GEN>
                {
                    for $Encoding in $webServiceEventLauncherRequest1//ns1:WebServiceEventInfo_WebServiceEventInfo_Item/ns1:item[1]/ns1:Encoding
                    return
                        <ns0:ENCODING>{ data($Encoding) }</ns0:ENCODING>
                }
                {
                    for $FileName1 in $webServiceEventLauncherRequest1//ns1:WebServiceEventInfo_WebServiceEventInfo_Item/ns1:item[1]/ns1:FileName1
                    return
                        <ns0:FILE_NAME>{ data($FileName1) }</ns0:FILE_NAME>
                }
                {
                    for $Partition in $webServiceEventLauncherRequest1//ns1:WebServiceEventInfo_WebServiceEventInfo_Item/ns1:item[1]/ns1:Partition
                    return
                        <ns0:PARTITION>{ data($Partition) }</ns0:PARTITION>
                }
                {
                    for $StartDate in $webServiceEventLauncherRequest1//ns1:WebServiceEventInfo_WebServiceEventInfo_Item/ns1:item[1]/ns1:StartDate
                    return
                        <ns0:STARTDATE>{ xs:string( fn:concat(fn:substring(data($StartDate),1,4),"/",fn:substring(data($StartDate),6,2),"/",fn:substring(data($StartDate),9,2)) ) }</ns0:STARTDATE>
                }
                {
                    for $Variant in $webServiceEventLauncherRequest1//ns1:WebServiceEventInfo_WebServiceEventInfo_Item/ns1:item[1]/ns1:Variant
                    return
                        <ns0:VARIANT>{ data($Variant) }</ns0:VARIANT>
                }
            </ns0:ZARIBA_MATERIAL_GEN>
        </ns0:MaterialGeneralImport>
};

declare variable $in.body as xs:string external;
declare variable $webServiceEventLauncherRequest1 as document-node() := fn:parse-xml($in.body);

xf:MaterialGeneralImport_TR_V1($webServiceEventLauncherRequest1)
