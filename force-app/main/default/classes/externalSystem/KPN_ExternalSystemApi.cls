/**
 * @description  : External System Requests Router
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-10
**/
public class KPN_ExternalSystemApi {
    public static final Integer API_TIMEOUT = 10000;
    public static final Integer SUCCESS_CODE = 200;

    public static final String NAMED_CREDENTIAL {
        public get {
            if (String.isBlank(NAMED_CREDENTIAL)) {
                NAMED_CREDENTIAL = 'callout:External_Api';
            }

            return NAMED_CREDENTIAL;
        }
        private set;
    }

    public KPN_ExternalSystemApi() {
    }

    public static String getEndpoint(String resource) {
        return NAMED_CREDENTIAL + resource;
    }

    public KPN_ExternalSystemResponse doPost(String resource, String body) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(API_TIMEOUT);
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(KPN_ExternalSystemApi.getEndpoint(resource));
        req.setBody(body);
        KPN_ExternalSystemResponse apiResponse = this.sendRequest(req);
        return apiResponse;
    }

    @TestVisible
    private static HttpResponse send(HttpRequest req) {
        HttpResponse res;
        try {
            res = new Http().send(req);
        } catch (CalloutException ce) {
            System.debug(LoggingLevel.ERROR, ce.getMessage());
            throw new KPN_ExternalSystemApiException(ce.getMessage(), ce);
        }

        return res;
    }

    public KPN_ExternalSystemResponse sendRequest(HttpRequest req) {
        KPN_ExternalSystemResponse apiResponse = new KPN_ExternalSystemResponse();
        HttpResponse res = KPN_ExternalSystemApi.send(req);
        if (res.getStatusCode() == SUCCESS_CODE) {
            apiResponse.rawJson = res.getBody();
            apiResponse.isSuccess = true;
        } else {
            apiResponse.rawJson = res.getBody();
            apiResponse.isSuccess = false;
        }

        return apiResponse;
    }

    public class KPN_ExternalSystemApiException extends Exception {
    }
}
