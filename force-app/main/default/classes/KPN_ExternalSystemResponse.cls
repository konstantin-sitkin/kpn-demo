public class KPN_ExternalSystemResponse {
    public Boolean isSuccess;
    public String rawJson;

    public KPN_ExternalSystemResponse() {
        this.isSuccess = true;
        this.rawJson = '';
    }

    public KPN_ExternalSystemResponse parse(String jsonStr) {
        return new KPN_ExternalSystemResponse();
    }
}