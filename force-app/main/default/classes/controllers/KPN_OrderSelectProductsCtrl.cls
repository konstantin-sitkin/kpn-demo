/**
 * @description  : Controller for LWC kpnOrderSelectProducts
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-09
 **/
public with sharing class KPN_OrderSelectProductsCtrl {
    /**
     * @description cacheable total of available PricebookEntries to predict last page
     * @author Konstantin Sitkin | 2022-08-09
     * @param orderId
     * @return Integer
     **/
    @AuraEnabled(cacheable=false)
    public static Integer getOrderableProductsCount(String orderId) {
        Order currentOrder = KPN_OrderSelector.getByIdWithChildren(orderId);
        Integer pbesTotal;
        
        if (currentOrder.Status == KPN_AppConstants.ORDER_STATUS_ACTIVATED) {
            List<Id> existingPbeIds = new List<Id>();
            for (OrderItem oItem : currentOrder.OrderItems) {
                existingPbeIds.add(oItem.PricebookEntryId);
            }
            pbesTotal = [
                SELECT Count()
                FROM PricebookEntry
                WHERE Pricebook2Id = :currentOrder.PriceBook2Id 
                AND IsActive = TRUE
                AND Id IN :existingPbeIds
            ];
        } else {
            pbesTotal = [
                SELECT Count()
                FROM PricebookEntry
                WHERE Pricebook2Id = :currentOrder.PriceBook2Id 
                AND IsActive = TRUE
            ];
        }

        return pbesTotal;
    }

    /**
    * @description Request for paged products with given offset and page size
    * @author Konstantin Sitkin | 2022-08-09 
    * @param orderId 
    * @param offset 
    * @return AvailableProductsResponse 
    **/
    @AuraEnabled(cacheable=false)
    public static AvailableProductsResponse getOrderableProducts(String orderId, Integer offset) {
        Order currentOrder = KPN_OrderSelector.getByIdWithChildren(orderId);
        List<PricebookEntry> pbes;
        
        if (currentOrder.Status == KPN_AppConstants.ORDER_STATUS_ACTIVATED) {
            List<Id> existingPbeIds = new List<Id>();
            for (OrderItem oItem : currentOrder.OrderItems) {
                existingPbeIds.add(oItem.PricebookEntryId);
            }
            pbes = [
                SELECT Id, Name, UnitPrice, Product2Id, IsActive
                FROM PricebookEntry
                WHERE Pricebook2Id = :currentOrder.PriceBook2Id 
                AND IsActive = TRUE
                AND Id IN :existingPbeIds
                WITH SECURITY_ENFORCED
                ORDER BY Name
                LIMIT :KPN_AppConstants.PRODUCTS_PAGE_SIZE
                OFFSET :offset
            ];
        } else {
            pbes = [
                SELECT Id, Name, UnitPrice, Product2Id, IsActive
                FROM PricebookEntry
                WHERE Pricebook2Id = :currentOrder.PriceBook2Id 
                AND IsActive = TRUE
                WITH SECURITY_ENFORCED
                ORDER BY Name
                LIMIT :KPN_AppConstants.PRODUCTS_PAGE_SIZE
                OFFSET :offset
            ];
        }

        AvailableProductsResponse res = new AvailableProductsResponse();
        res.offset = offset;
        res.consume(pbes);
        return res;
    }

    /**
     * @description  : Paged Wrapper for available products with extra attributes
     * @author       : Konstantin Sitkin
     * @created by   : 2022-08-09
     **/
    public class AvailableProductsResponse {
        @AuraEnabled
        public List<AvailableProduct> availableProducts;
        @AuraEnabled
        public Integer offset;
        @AuraEnabled
        public Integer pageSize;
        @AuraEnabled
        public Integer availableProductsCount;

        public AvailableProductsResponse() {
            this.availableProducts = new List<AvailableProduct>();
            this.availableProductsCount = 0;
            this.offset = 0;
            this.pageSize = KPN_AppConstants.PRODUCTS_PAGE_SIZE;
        }

        public void consume(List<PricebookEntry> pbes) {
            for (PricebookEntry pbe : pbes) {
                this.consume(pbe);
            }
        }

        public void consume(PricebookEntry pbe) {
            AvailableProduct ap = new AvailableProduct(pbe);
            this.availableProducts.add(ap);
            this.availableProductsCount += 1;
        }
    }

    /**
     * @description  : Product/PriceBookEntry wrapper
     * @author       : Konstantin Sitkin
     * @created by   : 2022-08-09
     **/
    public class AvailableProduct {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Decimal listPrice;
        @AuraEnabled
        public String pbeId;
        @AuraEnabled
        public String productId;
        public AvailableProduct() {
        }

        public AvailableProduct(PricebookEntry pbe) {
            this();
            this.name = pbe.Name;
            this.listPrice = pbe.UnitPrice;
            this.pbeId = pbe.Id;
            this.productId = pbe.Product2Id;
        }
    }
}
