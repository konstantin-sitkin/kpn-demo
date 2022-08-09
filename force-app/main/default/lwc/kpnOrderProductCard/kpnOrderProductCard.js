import { LightningElement, api, wire } from "lwc";
import { parseApexException } from "c/kpnUtils";

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
            parseApexException(e);
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

        const payload = { data: response };
        publish(this.messageContext, CHANNEL_ORDER_ITEM_CHANGE, payload);
    }
}
