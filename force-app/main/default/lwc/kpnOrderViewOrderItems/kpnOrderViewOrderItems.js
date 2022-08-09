import { LightningElement, api, wire } from "lwc";
import { parseApexException, showErrorToast, showSuccessToast, showValidationToast } from "c/kpnUtils";

import { subscribe, MessageContext } from "lightning/messageService";
import CHANNEL_ORDER_ITEM_CHANGE from "@salesforce/messageChannel/OrderItemChange__c";

import apexGetOrderItems from "@salesforce/apex/KPN_OrderViewOrderItemsCtrl.getOrderItems";
const columns = [
    { label: "Name", fieldName: "name", iconName: "standard:order_item"},
    { label: "Unit Price", fieldName: "unitPrice", type: "currency", iconName: "utility:currency" },
    { label: "Quantity", fieldName: "quantity", type: "number" },
    { label: "Total Price", fieldName: "totalPrice", type: "currency", iconName: "utility:currency" },
];
// just one background class to highlight updated row with green color
const CELL_COLOR_CLASS = {
    success: "slds-icon-custom-custom74",
};
const RESET_STYLING_INTERVAL = 2000;
export default class OrderViewOrderItems extends LightningElement {
    // api
    @api
    recordId;
    // wire
    @wire(MessageContext)
    messageContext;
    // dynamic
    tableItems = [];
    tableColumns = columns;
    orderItemChangeSubscription;
    recordsReceived = [];

    connectedCallback() {
        this.subscribeToMessageChannels();
        // set common attributes for all columns
        this.processTableColumns();
        // single call to populate table with existing order items
        this.getOrderItemsSafe();
    }

    subscribeToMessageChannels() {
        this.orderItemChangeSubscription = subscribe(this.messageContext, CHANNEL_ORDER_ITEM_CHANGE, (message) => this.handleOrderItemChangeMessage(message));
    }

    async handleOrderItemChangeMessage(message) {
        console.log("LMS Order", message);
        // save received record for future use / delayed processing
        this.recordsReceived.push({
            ...message.data,
            receivedDate: Date.now,
        });
        // channel has a single attribute "data"
        this.syncReceivedRecord(message.data);
    }

    async getOrderItemsSafe() {
        try {
            await this.getOrderItems();
        } catch (e) {
            parseApexException(e);
            showErrorToast(this, e);
        }
    }

    async getOrderItems() {
        let response = await apexGetOrderItems({
            orderId: this.recordId,
        });
        console.log("received order items", response);
        this.buildTableData(response);
    }

    processTableColumns() {
        this.tableColumns.forEach((tableColumn) => {
            // hid column wrap/clip actions
            tableColumn.hideDefaultActions = true;
            // assigned fieldName containing class to highlight row
            tableColumn.cellAttributes = { class: { fieldName: "cellUpdatedClass" } };
        });
    }

    async syncReceivedRecord(orderItemRecord) {
        // allow recently updated rows to have highlight class at least 2sec
        clearInterval(this.stylingTimeout);
        let tableItemReceived = this.buildTableItem(orderItemRecord);
        // highlight row as new
        tableItemReceived.cellUpdatedClass = CELL_COLOR_CLASS.success;
        // find existing row
        let tableItemExisting = this.tableItems.find((tableItem) => {
            return tableItem.itemId === tableItemReceived.itemId;
        });
        if (!tableItemExisting) {
            // add row as first if not found in table
            this.tableItems = [tableItemReceived, ...this.tableItems];
        } else {
            // assign object attributes if row exists
            Object.assign(tableItemExisting, tableItemReceived);
            // spread array to create new reference and rerender table
            this.tableItems = [...this.tableItems];
        }

        this.stylingTimeout = await this.delay(RESET_STYLING_INTERVAL, this.resetStyling.bind(this));
    }

    resetStyling() {
        // reset highlight class for all rows
        this.tableItems.forEach((tableItem) => {
            tableItem.cellUpdatedClass = "";
        });
        // spread array to create new reference and rerender table
        this.tableItems = [...this.tableItems];
    }

    buildTableData(orderItemRecords) {
        let tableItems = [];
        orderItemRecords.forEach((orderItemRecord) => {
            let tableItem = this.buildTableItem(orderItemRecord);
            tableItems.push(tableItem);
        });
        // reassigns variable reference to rerender table
        this.tableItems = tableItems;
    }

    buildTableItem(orderItemRecord) {
        // OrderItem to table row converter, loosely coupled wrapper
        let tableItem = {
            itemId: orderItemRecord.Id,
            name: orderItemRecord.Product2.Name,
            unitPrice: orderItemRecord.UnitPrice,
            quantity: orderItemRecord.Quantity,
            totalPrice: orderItemRecord.TotalPrice,
        };
        return tableItem;
    }

    // async function to enable component interactivity
    delay(ms, func) {
        return new Promise((resolve) => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            let timeoutId = setTimeout(func, ms);
            resolve(timeoutId);
        });
    }

    errorCallback(error, stack) {
        console.error(error, stack);
        showErrorToast(this, error);
    }
}
