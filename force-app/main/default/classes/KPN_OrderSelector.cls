/**
 * @description  : Selector pattern implementation for Order
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-09
**/
public with sharing class KPN_OrderSelector {
    /**
    * @description Order Selector by Order.Id
    * @author Konstantin Sitkin | 2022-08-09 
    * @param orderId 
    * @return Order 
    * @throws OrderSelectorException 
    **/
    public static Order getById(String orderId) {
        List<Order> records = [
            SELECT Id, Status,
            PriceBook2Id
            FROM Order
            WHERE Id = :orderId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        if (records.isEmpty()) {
            throw new OrderSelectorException('No records found for id: ' + orderId);
        }
        return records.get(0);
    }

    /**
    * @description Order Selector by Order.Id with Order Items
    * @author Konstantin Sitkin | 2022-08-09 
    * @param orderId 
    * @return Order 
    * @throws OrderSelectorException 
    **/
    public static Order getByIdWithChildren(String orderId) {
        List<Order> records = [
            SELECT Id, 
                Type,
                Status, 
                OrderNumber,
                PriceBook2Id,
                Account.AccountNumber,
                (
                    SELECT Id,
                        Product2.Name, 
                        Product2.ProductCode, 
                        UnitPrice, 
                        Quantity,
                        PricebookEntryId
                    FROM OrderItems
                )
            FROM Order
            WHERE Id = :orderId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        if (records.isEmpty()) {
            throw new OrderSelectorException('No records found for id: ' + orderId);
        }
        return records.get(0);
    }

    public class OrderSelectorException extends Exception {
        
    }
}