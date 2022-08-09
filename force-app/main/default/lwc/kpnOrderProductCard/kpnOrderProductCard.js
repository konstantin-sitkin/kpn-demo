import { LightningElement, api, wire } from "lwc";
import { parseApexException, showErrorToast, showSuccessToast, showValidationToast } from "c/kpnUtils";

import { publish, MessageContext } from "lightning/messageService";
import CHANNEL_ORDER_ITEM_CHANGE from "@salesforce/messageChannel/OrderItemChange__c";

import apexAddProduct from "@salesforce/apex/KPN_OrderProductCtrl.addProduct";

export default class OrderProductCard extends LightningElement {
    // constants
    labels = {
        buttonAdd: "Add",
        fieldListPrice: "List Price",
    };
    // dynamic
    showSpinner = false;
    _availableProduct = {};
    _orderId;
    // getters
    @api get availableProduct() {
        return this._availableProduct;
    }
    set availableProduct(value) {
        if (value) {
            this._availableProduct = value;
        }
    }

    @api get orderId() {
        return this._orderId;
    }
    set orderId(value) {
        this._orderId = value;
    }

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.showSpinner = false;
    }

    handleButtonAddClick(event) {
        this.addProductSafe();
    }

    async addProductSafe() {
        this.showSpinner = true;
        try {
            await this.addProduct();
        } catch (e) {
            let errorMsg = parseApexException(e);
            showErrorToast(this, errorMsg);
        } finally {
            this.showSpinner = false;
        }
    }

    async addProduct() {
        let response = await apexAddProduct({
            pbeId: this._availableProduct.pbeId,
            orderId: this._orderId,
        });
        console.log("upserted OrderItem", response);
        let message = this.buildProductAddedSuccessMessage(response);
        showSuccessToast(this, message);
        const payload = { data: response };
        // LMS should be enough for components on a single page
        publish(this.messageContext, CHANNEL_ORDER_ITEM_CHANGE, payload);
    }

    buildProductAddedSuccessMessage(orderItem) {
        let message;
        let productName = orderItem.Product2.Name || 'Product';
        let quantity = orderItem.Quantity;
        // it's a new order item
        if (quantity === 1) {
            message = `${productName} was Added to Order`;
        } else {
            // it's an existing order item
            message = `${productName} was Updated with Quantity ${quantity}`;
        }
        return message;
    }
}
