public class KPN_ExternalSystemPostOrderRequest {
    public String accountNumber;
    public String orderNumber;
    public String type;
    public String status;
    public List<OrderProduct> orderProducts;

    public KPN_ExternalSystemPostOrderRequest() {
        this.orderProducts = new List<OrderProduct>();
    }

    public void setOrder(Order ord) {
        this.accountNumber = ord.Account.AccountNumber;
        this.orderNumber = ord.OrderNumber;
        this.type = ord.Type;
        this.status = ord.Status;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        for (OrderItem orderItem : orderItems) {
            this.orderProducts.add(new OrderProduct(orderItem));
        }
    }

    public class OrderProduct {
        public String name;
        public String code;
        public Decimal unitPrice;
        public Integer quantity;

        public OrderProduct() {
        }

        public OrderProduct(OrderItem orderItem) {
            this();
            this.name = orderItem.Product2.Name;
            this.code = orderItem.Product2.ProductCode;
            this.unitPrice = orderItem.UnitPrice.setScale(2);
            this.quantity = Integer.valueOf(orderItem.Quantity);
        }
    }

    public static KPN_ExternalSystemPostOrderRequest parse(String json) {
        return (KPN_ExternalSystemPostOrderRequest) System.JSON.deserialize(json, KPN_ExternalSystemPostOrderRequest.class);
    }
}
