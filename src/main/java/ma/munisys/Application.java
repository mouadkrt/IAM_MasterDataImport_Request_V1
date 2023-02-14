package ma.munisys;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.apache.camel.Consume;
import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.builder.xml.Namespaces;
import org.apache.camel.builder.xml.XPathBuilder;
import org.apache.camel.language.XPath;
import org.apache.camel.processor.aggregate.AggregationStrategy;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SpringBootApplication
public class Application extends RouteBuilder {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }


/*     @Override 
    public void configure() {
        //Unit testing :
        from("netty4-http:http:0.0.0.0:8087")
        .convertBodyTo(String.class)
        .to("xquery:xqueries/Header_TR_V1.0.Xquery")
        .log(LoggingLevel.INFO, "Backend response in.headers: \n${in.headers}")
        .log(LoggingLevel.INFO, "Backend response body: \n${body}");

        // Original SOA body transformation : 
        // fn:concat("MasterDataImport_Request_V1/transformations/",$body/urn:WebServiceEventLauncherRequest/urn:WebServiceEventInfo_WebServiceEventInfo_Item/urn:item/urn:Flux,"_TR_V1.0")
    } */

    @Override
    public void configure() {

        //from("netty4-http:proxy://0.0.0.0:8087")
        from("netty4-http:http:0.0.0.0:8087")
            .routeId("muis_route1")
            .multicast(new transformRequest())
            .aggregationStrategyMethodAllowNull()
            .parallelProcessing()
            .to("direct:muis_trans_req_header","direct:muis_trans_req_body")
            //.to("direct:muis_trans_req_header")
        .end();

          /*   .toD("netty4-http:"
                + "${headers." + Exchange.HTTP_SCHEME + "}://"
                + "${headers." + Exchange.HTTP_HOST + "}:"
                + "${headers." + Exchange.HTTP_PORT + "}"
                + "${headers." + Exchange.HTTP_PATH + "}")
            .convertBodyTo(String.class)
            .log(LoggingLevel.INFO, "Backend response in.headers: \n${in.headers}")
            .log(LoggingLevel.INFO, "Backend response body: \n${body}");
   */
        
                
                from("direct:muis_trans_req_header")
                    .routeId("muis_route1.1")
                    .log("muis_route1.1 ('direct:muis_trans_req_header') is being invoked ...")
                    .convertBodyTo(String.class)
                    //.to("xquery:file:/Transform/Header.Xquery")
                    //.to("xquery:xqueries/get_Flux.Xquery");
                    .to("xquery:xqueries/Header_TR_V1.0.Xquery")
                .end();


                Namespaces ns = new Namespaces("ns0", "urn:Ariba:Buyer:vsap");

                from("direct:muis_trans_req_body")
                    .routeId("muis_route 1.2")
                    .log("muis_route 1.2 ('direct:muis_trans_req_body') is being invoked ...")
                    .convertBodyTo(String.class)
                    //.to("xquery:file:/Transform/Request.Xquery")
                    //.filter().method("myBean", "isGoldCustomer")
                    //.filter().xpath("/urn:WebServiceEventLauncherRequest/urn:WebServiceEventInfo_WebServiceEventInfo_Item/urn:item/urn:Flux", ns).to("mock:result")
                    //.to("xquery:xqueries/get_Flux.Xquery")
                    //.to("xquery:xqueries/MaterialTextImport_TR_V1.0.Xquery")
                    //.setHeader("Flux", constant("MaterialTextImport"))
                    .setHeader("Flux", ns.xpath(
                        "//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Flux/text()",   
                        String.class) 
                    )
                    .log(LoggingLevel.INFO, "Flux detected: ${in.headers.Flux}")
                    .toD("xquery:xqueries/${in.headers.Flux}_TR_V1.0.Xquery")
                    //.to("xquery:xqueries/" + XPathBuilder.xpath("//urn:WebServiceEventLauncherRequest/urn:WebServiceEventInfo_WebServiceEventInfo_Item/urn:item/urn:Flux", String.class) + "_TR_V1.0.Xquery")
                .end();

       //.transform().xquery("Receipt_Transfer_Header.Xquery", "urn:Ariba:Buyer:vsap");
    } 
}

/* class myBean {
    public boolean isGoldCustomer(Exchange exchange) {
       // ...
    }
  } */

class transformRequest implements AggregationStrategy  {
    private static final Logger LOGGER = LoggerFactory.getLogger(transformRequest.class.getName());

    @Override   
    public Exchange aggregate(Exchange oldExchange, Exchange newExchange) {

        if(oldExchange == null) {
            return newExchange;
        }
 
        String oldBody = oldExchange.getIn().getBody(String.class);
        LOGGER.info("Inside aggregator oldExchange : " + oldBody);

        String newBody = newExchange.getIn().getBody(String.class);
        LOGGER.info("Inside aggregator newExchange : " + newBody);
        
        String mergedStr = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
                                "<soapenv:Header>" +
                                    oldBody +
                                "</soapenv:Header>" +
                                "<soap:Body xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" +
                                newBody +
                                "</soap:Body>" +
                            "</soapenv:Envelope>";
        
        newExchange.getIn().setBody(mergedStr);

        LOGGER.info("Inside aggregator merged Exchange : " + newExchange.getIn().getBody());        
        return newExchange;
    }

}
