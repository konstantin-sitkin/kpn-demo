List<Product2> products = [
    SELECT Description, DisplayUrl, Family, Id, IsActive,
    Name, ProductCode, QuantityUnitOfMeasure
  FROM Product2
];
Integer order = 1;

for (Product2 prd : products) {
    String capsName = prd.name.replaceAll('[a-z ,\'&-.+:]+', '');
    capsName = capsName.rightPad(4, 'X');
    capsName = capsName.substring(0, 4);
    String productCode = capsName + String.valueOf(order).leftPad(3, '0');
    prd.ProductCode = productCode;
    prd.IsActive = true;
    prd.Family = 'Books';
    order += 1;
    System.debug(productCode);
}
update products;