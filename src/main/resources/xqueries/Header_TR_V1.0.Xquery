xquery version "1.0";
(:: pragma bea:global-element-parameter parameter="$webServiceEventLauncherRequest1" element="ns0:WebServiceEventLauncherRequest" location="../WSDLs/WebServiceEventLauncher.wsdl" ::)
(:: pragma bea:global-element-return element="ns1:ibsinfo" location="../WSDLs/CompanyCodeImport_V1.wsdl" ::)

declare namespace ns1 = "urn:schemas-iwaysoftware-com:iwse";
declare namespace ns0 = "urn:Ariba:Buyer:vsap";
declare namespace xf = "http://tempuri.org/MasterDataImport_Request_V1/transformations/Header_TR_V1.0/";

declare function xf:Header_TR_V1($webServiceEventLauncherRequest1 as document-node())
    as element(ns1:ibsinfo) {
        <ns1:ibsinfo>
            <ns1:service>{ fn:concat(data($webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Flux),"_V1") }</ns1:service>
            <ns1:method>{ data($webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Flux) }</ns1:method>
            <ns1:license>test</ns1:license>
            {
                for $Login in $webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Login
                return
                    <ns1:Username>{ data($Login) }</ns1:Username>
            }
            {
                for $Password in $webServiceEventLauncherRequest1//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Password
                return
                    <ns1:Password>{ data($Password) }</ns1:Password>
            }
        </ns1:ibsinfo>
};

declare variable $in.body as xs:string external;
declare variable $webServiceEventLauncherRequest1 as document-node() := fn:parse-xml($in.body);

xf:Header_TR_V1($webServiceEventLauncherRequest1)