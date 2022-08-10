/**
 * @description  : External System common response
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-10
**/
public class KPN_ExternalSystemResponse {
    public Boolean isSuccess;
    public String rawJson;

    public KPN_ExternalSystemResponse() {
        this.isSuccess = true;
        this.rawJson = '';
    }
}