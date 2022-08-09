import { LightningElement, api, wire } from "lwc";
import { parseApexException } from "c/kpnUtils";

import { subscribe, MessageContext } from "lightning/messageService";
import CHANNEL_ORDER_ITEM_CHANGE from "@salesforce/messageChannel/OrderItemChange__c";

import apexGetOrderItems from "@salesforce/apex/KPN_OrderViewOrderItemsCtrl.getOrderItems";
const columns = [
    { label: "Name", fieldName: "name", iconName: "standard:order_item"},
    { label: "Unit Price", fieldName: "unitPrice", type: "currency", iconName: "utility:currency" },
    { label: "Quantity", fieldName: "quantity", type: "number" },
    { label: "Total Price", fieldName: "totalPrice", type: "currency", iconName: "utility:currency" },
];

const CELL_COLOR_CLASS = {
    success: "slds-icon-custom-custom74",
};
const RESET_STYLING_INTERVAL = 2000;
export default class OrderViewOrderItems extends LightningElement {
    tableItems = [];
    tableColumns = columns;

    @api
    recordId;

    @wire(MessageContext)
    messageContext;

    recordsReceived = [];

    connectedCallback() {
        this.subscribeToMessageChannels();
        this.processTableColumns();
        this.getOrderItemsSafe();
    }

    subscribeToMessageChannels() {
        this.filterSubscription = subscribe(this.messageContext, CHANNEL_ORDER_ITEM_CHANGE, (message) => this.handleOrderItemChangeMessage(message));
    }

    async handleOrderItemChangeMessage(message) {
        console.log("LMS Order", message);
        this.recordsReceived.push({
            ...message.data,
            receivedDate: Date.now,
        });
        this.syncReceivedRecord(message.data);
    }

    async getOrderItemsSafe() {
        try {
            await this.getOrderItems();
        } catch (e) {
            parseApexException(e);
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
            tableColumn.hideDefaultActions = true;
            tableColumn.cellAttributes = { class: { fieldName: "cellUpdatedClass" } };
        });
    }

    async syncReceivedRecord(orderItemRecord) {
        clearInterval(this.stylingTimeout);
        let tableItemReceived = this.buildTableItem(orderItemRecord);
        tableItemReceived.cellUpdatedClass = CELL_COLOR_CLASS.success;
        let tableItemExisting = this.tableItems.find((tableItem) => {
            return tableItem.itemId === tableItemReceived.itemId;
        });
        if (!tableItemExisting) {
            this.tableItems = [tableItemReceived, ...this.tableItems];
        } else {
            Object.assign(tableItemExisting, tableItemReceived);
            this.tableItems = [...this.tableItems];
        }

        this.stylingTimeout = await this.delay(RESET_STYLING_INTERVAL, this.resetStyling.bind(this));
    }

    resetStyling() {
        this.tableItems.forEach((tableItem) => {
            tableItem.cellUpdatedClass = "";
        });
        this.tableItems = [...this.tableItems];
    }

    buildTableData(orderItemRecords) {
        let tableItems = [];
        orderItemRecords.forEach((orderItemRecord) => {
            let tableItem = this.buildTableItem(orderItemRecord);
            tableItems.push(tableItem);
        });
        this.tableItems = tableItems;
    }

    buildTableItem(orderItemRecord) {
        let tableItem = {
            itemId: orderItemRecord.Id,
            name: orderItemRecord.Product2.Name,
            unitPrice: orderItemRecord.UnitPrice,
            quantity: orderItemRecord.Quantity,
            totalPrice: orderItemRecord.TotalPrice,
        };
        return tableItem;
    }

    delay(ms, func) {
        return new Promise((resolve) => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            let timeoutId = setTimeout(func, ms);
            resolve(timeoutId);
        });
    }

    errorCallback() {}
}
