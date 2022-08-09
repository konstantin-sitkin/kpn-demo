List<Product2> products = [
    SELECT Id, Name
    FROM Product2
];

for (Product2 prd : products) {
    List<String> parts = prd.Name.split(',');
    if (parts.size() > 1) {
        prd.Name = parts[1] + ' ' + parts[0];
        prd.Name = prd.Name.remove(',');
        System.debug(prd.Name);
    }
    
}
update products;

