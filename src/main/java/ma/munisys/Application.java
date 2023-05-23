package ma.munisys;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.UUID;

import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.builder.xml.Namespaces;
import org.apache.camel.processor.aggregate.AggregationStrategy;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SpringBootApplication
public class Application extends RouteBuilder {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Override
    public void configure() {

        from("netty4-http:proxy://0.0.0.0:8443?ssl=true&keyStoreFile=/keystore_iam.jks&passphrase=123.pwdMunisys&trustStoreFile=/keystore_iam.jks")
            .routeId("muis_route1")
            .log(LoggingLevel.INFO, "-------------- IAM_MasterDataImport_Request_V1 START -----------------------\n\n\n")
            .setHeader("X-Request-ID", constant(UUID.randomUUID()))
            .log(LoggingLevel.INFO, "Initial received header : \n${in.headers} \n")
            .log(LoggingLevel.INFO, "Initial received body : \n${body} \n")
            .multicast(new transformRequest())
            .aggregationStrategyMethodAllowNull()
            .parallelProcessing()
            .to("direct:muis_trans_req_header","direct:muis_trans_req_body")
        .end()

            .log(LoggingLevel.INFO, "MUIS toD : ${headers." + Exchange.HTTP_SCHEME + "}://"
                                    + "${headers." + Exchange.HTTP_HOST + "}:"
                                    + "${headers." + Exchange.HTTP_PORT + "}"
                                    + "${headers." + Exchange.HTTP_PATH + "} \n")
            .toD("netty4-http:"
                + "${headers." + Exchange.HTTP_SCHEME + "}://"
                + "${headers." + Exchange.HTTP_HOST + "}:"
                + "${headers." + Exchange.HTTP_PORT + "}"
                + "${headers." + Exchange.HTTP_PATH + "}")
            .convertBodyTo(String.class)
            .log(LoggingLevel.INFO, "Backend response in.headers: \n${in.headers}")
            .log(LoggingLevel.INFO, "Backend response body: \n${body}");
           
                
                from("direct:muis_trans_req_header")
                    .routeId("muis_route1.1")
                    .log("muis_route1.1 ('direct:muis_trans_req_header') is being invoked ...")
                    .convertBodyTo(String.class)
                    //.to("xquery:xqueries/Header_TR_V1.0.Xquery")
                    .to("xquery:file:/Transform/Header_TR_V1.0.Xquery")
                .end();

                Namespaces ns = new Namespaces("ns0", "urn:Ariba:Buyer:vsap");
                from("direct:muis_trans_req_body")
                    .routeId("muis_route 1.2")
                    .log("muis_route 1.2 ('direct:muis_trans_req_body') is being invoked ...")
                    .convertBodyTo(String.class)
                    .setHeader("Flux", ns.xpath(
                        "//ns0:WebServiceEventInfo_WebServiceEventInfo_Item/ns0:item[1]/ns0:Flux/text()",   
                        String.class) 
                    )
                    .log(LoggingLevel.INFO, "xPath text of the <Flux> xml tag resolved to : ${in.headers.Flux}")
                    .log(LoggingLevel.INFO, "Applying the following transformation : /Transform/${in.headers.Flux}_TR_V1.0.Xquery")
                    .toD("xquery:xqueries/${in.headers.Flux}_TR_V1.0.Xquery")
                    //.toD("xquery:file:/Transform/${in.headers.Flux}_TR_V1.0.Xquery")
                    .removeHeader("Flux")
                .end();
    } 
}

class transformRequest implements AggregationStrategy  {
    private static final Logger LOGGER = LoggerFactory.getLogger(transformRequest.class.getName());

    @Override   
    public Exchange aggregate(Exchange oldExchange, Exchange newExchange) {

        if(oldExchange == null) {
            return newExchange;
        }
 
        String oldBody = oldExchange.getIn().getBody(String.class);
        LOGGER.info("Inside aggregator oldExchange : " + oldBody + "\n");

        String newBody = newExchange.getIn().getBody(String.class);
        LOGGER.info("Inside aggregator newExchange : " + newBody + "\n");
        
        String mergedStr = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
                                "<soapenv:Header>" +
                                    oldBody +
                                "</soapenv:Header>" +
                                "<soap:Body xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" +
                                newBody +
                                "</soap:Body>" +
                            "</soapenv:Envelope>";
        
        newExchange.getIn().setBody(mergedStr);

        LOGGER.info("Inside aggregator merged Exchange : " + newExchange.getIn().getBody() + "\n");        
        return newExchange;
    }

}
