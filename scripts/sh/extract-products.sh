sfdx force:data:soql:query -q "SELECT Id, Name, ProductCode, Description, Family, IsActive FROM Product2" --resultformat csv > ./test-data/products.csv