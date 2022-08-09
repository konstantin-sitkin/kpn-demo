List<Product2> products = [
    SELECT Description, DisplayUrl, Family, Id, IsActive,
    Name, ProductCode, QuantityUnitOfMeasure
  FROM Product2
];
Pricebook2 pb = [
    SELECT Id, Name, IsStandard FROM Pricebook2
    WHERE IsStandard = TRUE
    LIMIT 1
];

List<PricebookEntry> pbes = new List<PricebookEntry>();
for (Product2 prd : products) {
    Decimal price = 10 + Decimal.valueof((Math.random() * 100)).setScale(2);
    PricebookEntry pbe = new PricebookEntry(
        Product2Id = prd.Id,
        Pricebook2Id = pb.Id,
        UnitPrice = price,
        IsActive = true
    );
    pbes.add(pbe);
}
insert pbes;

