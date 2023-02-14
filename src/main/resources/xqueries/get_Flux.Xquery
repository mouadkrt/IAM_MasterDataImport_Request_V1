xquery version "1.0";
declare variable $in.body as xs:string external;
fn:concat("xqueries/",$in.body/urn:WebServiceEventLauncherRequest/urn:WebServiceEventInfo_WebServiceEventInfo_Item/urn:item/urn:Flux,"_TR_V1.0.Xquery")