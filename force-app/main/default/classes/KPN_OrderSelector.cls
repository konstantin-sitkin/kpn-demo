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
            SELECT Id,
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

    public class OrderSelectorException extends Exception {
        
    }
}