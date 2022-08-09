import { LightningElement, api, wire } from "lwc";
import { parseApexException } from "c/kpnUtils";

import apexGetOrderableProducts from "@salesforce/apex/KPN_OrderSelectProductsCtrl.getOrderableProducts";
import apexGetOrderableProductsCount from "@salesforce/apex/KPN_OrderSelectProductsCtrl.getOrderableProductsCount";

export default class OrderSelectProducts extends LightningElement {
    @api
    recordId;
    currentOffset;
    pageSize;
    availableProducts = [];
    productsTotal;

    @api
    get previousDisabled() {
        return this.currentOffset === 0;
    }

    @api
    get nextDisabled() {
        return this.currentOffset + this.pageSize >= this.productsTotal;
    }

    connectedCallback() {
        this.currentOffset = 0;
        this.productsTotal = 0;
        this.pageSize = 0;
        console.log(this.recordId);
        this.getOrderableProductsSafe();
        this.getOrderableProductsCountSafe();
    }

    async getOrderableProductsSafe() {
        try {
            await this.getOrderableProducts();
        } catch (e) {
            parseApexException(e);
        }
    }

    async getOrderableProductsCountSafe() {
        try {
            await this.getOrderableProductsCount();
        } catch (e) {
            parseApexException(e);
        }
    }

    async getOrderableProductsCount() {
        let response = await apexGetOrderableProductsCount({
            orderId: this.recordId,
        });
        console.log("available products total", response);
        this.productsTotal = response;
    }

    async getOrderableProducts() {
        let response = await apexGetOrderableProducts({
            orderId: this.recordId,
            offset: this.currentOffset,
        });
        console.log(response);
        this.availableProducts = response.availableProducts;
        this.pageSize = response.pageSize;
    }

    handleButtonPreviousClick(event) {
        let offsetCalculated = this.currentOffset - this.pageSize;
        if (offsetCalculated < 0) {
            offsetCalculated = 0;
        }
        this.currentOffset = offsetCalculated;
        this.getOrderableProducts();
    }

    handleButtonNextClick(event) {
        let offsetCalculated = this.currentOffset + this.pageSize;
        if (offsetCalculated >= this.productsTotal) {
            offsetCalculated = this.productsTotal - this.pageSize;
        }
        this.currentOffset = offsetCalculated;
        this.getOrderableProducts();
    }

    disconnectedCallback() {}

    errorCallback(error, stack) {
        this.error = error;
    }
}
