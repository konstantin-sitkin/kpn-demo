public with sharing class KPN_OrderProductCtrl {
    
    @AuraEnabled(cacheable=false)
    public static OrderItem addProduct(String orderId, String pbeId) {
        PricebookEntry pbe = [
            SELECT Id, Name, UnitPrice, Product2Id
            FROM PricebookEntry
            WHERE Id = :pbeId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        List<OrderItem> orderItems = [
            SELECT Id, Quantity, PricebookEntryId, Product2Id, OrderId
            FROM OrderItem
            WHERE OrderId = :orderId
            AND PricebookEntryId = :pbeId
            WITH SECURITY_ENFORCED
        ];
        OrderItem orderItemToUpsert;
        if (orderItems.isEmpty()) {
            orderItemToUpsert = new OrderItem(
                OrderId = orderId,
                PricebookEntryId = pbe.Id,
                Product2Id = pbe.Product2Id,
                ListPrice = pbe.UnitPrice,
                UnitPrice = pbe.UnitPrice,
                Quantity = 1
            );
        } else {
            orderItemToUpsert = orderItems.get(0);
            orderItemToUpsert.Quantity += 1;
        }
        upsert orderItemToUpsert;

        return KPN_OrderItemSelector.getById(orderItemToUpsert.Id);
    }
}