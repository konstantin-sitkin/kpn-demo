/**
 * @description  : KPN Test Data Factory
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-09
 **/
@IsTest
public class KPN_TestDataFactory {
    public static Account createAccount() {
        Account acc = new Account(Name = 'Base Account');
        insert acc;
        return acc;
    }

    public static Contract createContract(Id accountId) {
        Contract ctr = new Contract(
            Name = 'Base Contract',
            AccountId = accountId,
            StartDate = Date.today().toStartOfMonth(),
            ContractTerm = 24,
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert ctr;
        return ctr;
    }

    public static Order createOrder(Id accountId, Id contractId) {
        Order ord = new Order(
            Name = 'Base Contract',
            AccountId = accountId,
            EffectiveDate = Date.today().toStartOfMonth(),
            Pricebook2Id = Test.getStandardPricebookId(),
            Status = 'Draft'
        );
        insert ord;
        return ord;
    }

    public static Map<String, OrderItem> createOrderItems(Id orderId, Integer count) {
        Id pbId = Test.getStandardPricebookId();
        List<PricebookEntry> pbes = [
            SELECT Id, Name, UnitPrice, Product2Id, IsActive, ProductCode
            FROM PricebookEntry
            WHERE Pricebook2Id = :pbId AND IsActive = TRUE
            LIMIT :count
        ];
        List<OrderItem> oItems = new List<OrderItem>();
        Map<String, OrderItem> productCodeToOIs = new Map<String, OrderItem>();
        for (PricebookEntry pbe : pbes) {
            OrderItem oItem = new OrderItem(
                OrderId = orderId,
                PricebookEntryId = pbe.Id,
                Product2Id = pbe.Product2Id,
                ListPrice = pbe.UnitPrice,
                UnitPrice = pbe.UnitPrice,
                Quantity = 1
            );
            oItems.add(oItem);
            productCodeToOIs.put(pbe.ProductCode, oItem);
        }

        insert oItems;
        return productCodeToOIs;
    }

    /**
     * @description Products are built once in sandbox and exported with sfdx command
     * @author Konstantin Sitkin | 2022-08-09
     * @return Map<String, PricebookEntry>
     **/
    public static Map<String, PricebookEntry> createProductsAndEntries() {
        List<Product2> products = Test.loadData(Product2.sObjectType, 'TestData_Products_json');
        Id pbId = Test.getStandardPricebookId();

        List<PricebookEntry> pbes = new List<PricebookEntry>();
        Map<String, PricebookEntry> productCodeToPBEs = new Map<String, PricebookEntry>();
        for (Product2 prd : products) {
            Decimal price = 10 + Decimal.valueof((Math.random() * 100)).setScale(2);
            PricebookEntry pbe = new PricebookEntry(Product2Id = prd.Id, Pricebook2Id = pbId, UnitPrice = price, IsActive = true);
            pbes.add(pbe);
            productCodeToPBEs.put(prd.ProductCode, pbe);
        }
        insert pbes;
        return productCodeToPBEs;
    }
}
