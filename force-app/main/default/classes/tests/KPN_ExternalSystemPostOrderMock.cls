/**
 * @description  : KPN_ExternalSystemPostOrderApiHandler Mock
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-10
 **/
@isTest
public class KPN_ExternalSystemPostOrderMock {
    public static StaticResourceCalloutMock getSuccessMock() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Mock_KPN_ExternalSystemPostOrderSuccess');
        mock.setStatusCode(200);
        return mock;
    }

    public static StaticResourceCalloutMock getErrorMock() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Mock_KPN_ExternalSystemPostOrderError');
        mock.setStatusCode(400);
        return mock;
    }

    public class CalloutExceptionMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            CalloutException e = (CalloutException) CalloutException.class.newInstance();
            e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
            throw e;
        }
    }
}
