import { LightningElement, api, wire } from "lwc";
import { parseApexException, showErrorToast, showSuccessToast, showValidationToast } from "c/kpnUtils";

import apexGetOrderableProducts from "@salesforce/apex/KPN_OrderSelectProductsCtrl.getOrderableProducts";
import apexGetOrderableProductsCount from "@salesforce/apex/KPN_OrderSelectProductsCtrl.getOrderableProductsCount";

export default class OrderSelectProducts extends LightningElement {
    // dynamic
    currentOffset; // products page offset
    pageSize; // products page size
    availableProducts = []; // wrapper of price book entries
    productsTotal; // total records validator for pagination
    // api
    @api
    recordId; // param from record page

    @api
    get previousDisabled() {
        return this.currentOffset === 0;
    }

    @api
    get nextDisabled() {
        return this.currentOffset + this.pageSize >= this.productsTotal;
    }

    @api
    get paginationEnabled() {
        return this.productsTotal > this.pageSize;
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
            let errorMsg = parseApexException(e);
            showErrorToast(this, errorMsg);
        }
    }

    async getOrderableProductsCountSafe() {
        try {
            await this.getOrderableProductsCount();
        } catch (e) {
            let errorMsg = parseApexException(e);
            showErrorToast(this, errorMsg);
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
        // get previous offset
        let offsetCalculated = this.currentOffset - this.pageSize;
        // normalize offset if it's the last page
        if (offsetCalculated < 0) {
            offsetCalculated = 0;
        }
        this.currentOffset = offsetCalculated;
        this.getOrderableProducts();
    }

    handleButtonNextClick(event) {
        // get next offset
        let offsetCalculated = this.currentOffset + this.pageSize;
        // normalize offset if it's the last page
        if (offsetCalculated >= this.productsTotal) {
            offsetCalculated = this.productsTotal - this.pageSize;
        }
        this.currentOffset = offsetCalculated;
        this.getOrderableProducts();
    }

    disconnectedCallback() {}

    errorCallback(error, stack) {
        console.error(error, stack);
        showErrorToast(this, error);
    }
}
