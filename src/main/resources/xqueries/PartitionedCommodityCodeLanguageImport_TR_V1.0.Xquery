xquery version "1.0";
(:: pragma bea:global-element-parameter parameter="$webServiceEventLauncherRequest1" element="ns0:WebServiceEventLauncherRequest" location="../WSDLs/WebServiceEventLauncher.wsdl" ::)
(:: pragma bea:global-element-return element="ns1:PartitionedCommodityCodeLanguageImport" location="../WSDLs/PartitionedCommodityCodeLanguageImport_V1.wsdl" ::)

declare namespace ns1 = "urn:iwaysoftware:ibse:jul2003:PartitionedCommodityCodeLanguageImport";
declare namespace ns0 = "urn:Ariba:Buyer:vsap";
declare namespace xf = "http://tempuri.org/MasterDataImport_Request_V1/transformations/PartitionedCommodityCodeLanguageImport_TR_V1.0/";

declare function xf:PartitionedCommodityCodeLanguageImport_TR_V1($webServiceEventLauncherRequest1 as document-node())
    as element(ns1:PartitionedCommodityCodeLanguageImport) {
        <ns1:PartitionedCommodityCodeLanguageImport>
            <ns1:ZARIBA_MATERIAL_GROUP_NAMES>
                {
                    for $Encoding in $webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Encoding
                    return
                        <ns1:ENCODING>{ data($Encoding) }</ns1:ENCODING>
                }
                {
                    for $FileName1 in $webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:FileName1
                    return
                        <ns1:FILE_NAME>{ data($FileName1) }</ns1:FILE_NAME>
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
            </ns1:ZARIBA_MATERIAL_GROUP_NAMES>
        </ns1:PartitionedCommodityCodeLanguageImport>
};

declare variable $in.body as xs:string external;
declare variable $webServiceEventLauncherRequest1 as document-node() := fn:parse-xml($in.body);

xf:PartitionedCommodityCodeLanguageImport_TR_V1($webServiceEventLauncherRequest1)