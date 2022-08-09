public class KPN_ExternalSystemPostOrderApiHandler implements KPN_ExternalSystemApiHandler {
    public KPN_ExternalSystemPostOrderApiHandler() {
        this.mOrder = new Order();
        this.mOrderItems = new List<OrderItem>();
    }

    protected Order mOrder;
    protected List<OrderItem> mOrderItems;

    @TestVisible
    private static String resourceBase = '/order/{0}/post';
    public String resource { get; private set; }

    public void buildResource() {
        this.resource = String.format(resourceBase, new List<String>{
            this.mOrder.OrderNumber
        });
    }

    public KPN_ExternalSystemApiHandler setOrder(Order ord) {
        this.mOrder = ord;
        this.buildResource();
        return this;
    }

    public KPN_ExternalSystemApiHandler setOrderItems(List<OrderItem> orderItems) {
        this.mOrderItems = orderItems;
        return this;
    }

    public KPN_ExternalSystemResponse doPost() {
        KPN_ExternalSystemApi api = new KPN_ExternalSystemApi();
        KPN_ExternalSystemPostOrderRequest requestDto = new KPN_ExternalSystemPostOrderRequest();
        requestDto.setOrder(this.mOrder);
        requestDto.setOrderItems(this.mOrderItems);
        String body = JSON.serialize(requestDto);
        KPN_ExternalSystemResponse apiRes = api.doPost(this.resource, body);
        return apiRes;
    }

}
