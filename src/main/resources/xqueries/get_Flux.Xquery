xquery version "1.0";
(:: pragma bea:global-element-parameter parameter="$webServiceEventLauncherRequest1" element="ns0:WebServiceEventLauncherRequest" location="../WSDLs/WebServiceEventLauncher.wsdl" ::)
(:: pragma bea:global-element-return element="ns1:MaterialTextImport" location="../WSDLs/MaterialTextImport_V1.wsdl" ::)

declare namespace ns1 = "urn:iwaysoftware:ibse:jul2003:MaterialTextImport";
declare namespace ns0 = "urn:Ariba:Buyer:vsap";
declare namespace xf = "http://tempuri.org/MasterDataImport_Request_V1/transformations/MaterialTextImport_TR_V1.0/";

declare function xf:MaterialTextImport_TR_V1($xml_body as document-node())
    as element(ns1:MaterialTextImport) {
        <ns1:MaterialTextImport>
                {
                   $xml_body//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Flux/text()
                }

        </ns1:MaterialTextImport>
};

declare variable $in.body as xs:string external;
declare variable $xml_body as document-node() := fn:parse-xml($in.body);

xf:MaterialTextImport_TR_V1($xml_body)