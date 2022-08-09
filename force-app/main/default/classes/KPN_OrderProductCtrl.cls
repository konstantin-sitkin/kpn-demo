/**
 * @description  : Controller for LWC kpnOrderProductCard.js
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-09
**/
public with sharing class KPN_OrderProductCtrl {
    
    /**
    * @description Creates or Updates OrderItem based on selected PriceBookEntry.Id 
    * @author Konstantin Sitkin | 2022-08-09 
    * @param orderId 
    * @param pbeId 
    * @return OrderItem 
    **/
    @AuraEnabled(cacheable=false)
    public static OrderItem addProduct(String orderId, String pbeId) {
        // query PBE for extra fields
        PricebookEntry pbe = [
            SELECT Id, Name, UnitPrice, Product2Id
            FROM PricebookEntry
            WHERE Id = :pbeId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        // get existing order items for current order
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
        // return updated order item with extra fields
        // selector and fields are the same for add and view OrderItem
        return KPN_OrderItemSelector.getById(orderItemToUpsert.Id);
    }
}