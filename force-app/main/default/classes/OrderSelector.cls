public with sharing class OrderSelector {
    public static Order getById(String orderId) {
        Order record = [
            SELECT Id,
            PriceBook2Id
            FROM Order
            WHERE Id = :orderId
            LIMIT 1
        ];
        return record;
    }
}
