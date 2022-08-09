public with sharing class KPN_OrderSelectProductsCtrl {

    @AuraEnabled(cacheable=true)
    public static Integer getOrderableProductsCount(String orderId) {
        Order currentOrder = KPN_OrderSelector.getById(orderId);
        Integer pbesTotal = [
            SELECT Count() 
            FROM PricebookEntry
            WHERE Pricebook2Id = :currentOrder.PriceBook2Id
            AND IsActive = TRUE
            WITH SECURITY_ENFORCED
        ];
        return pbesTotal;
    }

    @AuraEnabled(cacheable=false)
    public static AvailableProductsResponse getOrderableProducts(String orderId, Integer offset) {
        Order currentOrder = KPN_OrderSelector.getById(orderId);
        List<PricebookEntry> pbes = [
            SELECT Id, Name, UnitPrice, Product2Id, IsActive
            FROM PricebookEntry
            WHERE Pricebook2Id = :currentOrder.PriceBook2Id
            AND IsActive = TRUE
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT :KPN_AppConstants.PRODUCTS_PAGE_SIZE
            OFFSET :offset
        ];

        AvailableProductsResponse res = new AvailableProductsResponse();
        res.offset = offset;
        res.consume(pbes);
        return res;
    }
    
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

    public class AvailableProduct {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Decimal listPrice;
        @AuraEnabled
        public String pbeId;
        @AuraEnabled
        public String productId;
        public AvailableProduct() {}

        public AvailableProduct(PricebookEntry pbe) {
            this();
            this.name = pbe.Name;
            this.listPrice = pbe.UnitPrice;
            this.pbeId = pbe.Id;
            this.productId = pbe.Product2Id;
        }
    }

}