xquery version "1.0";
(:: pragma bea:global-element-parameter parameter="$webServiceEventLauncherRequest1" element="ns0:WebServiceEventLauncherRequest" location="../WSDLs/WebServiceEventLauncher.wsdl" ::)
(:: pragma bea:global-element-return element="ns1:SupplierImport" location="../WSDLs/SupplierImport_V1.wsdl" ::)

declare namespace ns1 = "urn:iwaysoftware:ibse:jul2003:SupplierImport";
declare namespace ns0 = "urn:Ariba:Buyer:vsap";
declare namespace xf = "http://tempuri.org/MasterDataImport_Request_V1/transformations/SupplierImport_TR_V1.0/";

declare function xf:SupplierImport_TR_V1($webServiceEventLauncherRequest1 as document-node())
    as element(ns1:SupplierImport) {
        <ns1:SupplierImport>
            <ns1:ZARIBA_VENDOR>
                {
                    for $Encoding in $webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Encoding
                    return
                        <ns1:ENCODING>{ data($Encoding) }</ns1:ENCODING>
                }
                {
                    for $FileName2 in $webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:FileName2
                    return
                        <ns1:FILE_NAME_PORG_VEN>{ data($FileName2) }</ns1:FILE_NAME_PORG_VEN>
                }
                {
                    for $FileName1 in $webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:FileName1
                    return
                        <ns1:FILE_NAME_VENDOR>{ data($FileName1) }</ns1:FILE_NAME_VENDOR>
                }
                {
                    for $Partition in $webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Partition
                    return
                        <ns1:PARTITION>{ data($Partition) }</ns1:PARTITION>
                }
                {
                    for $Variant in $webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Variant
                    return
                        <ns1:VARIANT>{ data($Variant) }</ns1:VARIANT>
                }
            </ns1:ZARIBA_VENDOR>
        </ns1:SupplierImport>
};

declare variable $in.body as xs:string external;
declare variable $webServiceEventLauncherRequest1 as document-node() := fn:parse-xml($in.body);

xf:SupplierImport_TR_V1($webServiceEventLauncherRequest1)