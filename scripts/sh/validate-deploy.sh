sfdx force:source:deploy \
-p=force-app \
--testlevel=RunSpecifiedTests \
--runtests=KPN_OrderItemSelectorTest,KPN_OrderProductCtrlTest,KPN_TestDataFactory,KPN_OrderSelectProductsCtrlTest,KPN_OrderViewOrderItemsCtrlTest,KPN_OrderSelectorTest \
--checkonly \
-u=$1