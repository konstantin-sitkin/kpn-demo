public with sharing class OrderSelector {
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
