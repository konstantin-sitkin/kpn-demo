import { LightningElement, api, wire } from "lwc";
import { getRecord, getRecordNotifyChange } from "lightning/uiRecordApi";
import { FlowNavigationFinishEvent } from "lightning/flowSupport";
import { parseApexException, showErrorToast, showSuccessToast, showValidationToast } from "c/kpnUtils";

import apexPostOrder from "@salesforce/apex/KPN_OrderConfirmationCtrl.postOrder";

import FIELD_STATUS from "@salesforce/schema/Order.Status";

const ORDER_STATUS_ACTIVATED = "Activated";
export default class OrderESConfirmation extends LightningElement {
    @api recordId;

    isOrderProcessing;
    isFlowAlreadyLaunched = false;

    @wire(getRecord, { recordId: "$recordId", fields: [FIELD_STATUS] })
    wiredRecord({ error, data }) {
        if (data) {
            this.orderStatus = data.fields.Status.value;
            console.log(this.orderStatus);
            this.checkOrderValidity();
        } else if (error) {
            console.log("error data", error);
        }
    }

    connectedCallback() {
        console.log(this.recordId);
    }

    errorCallback() {}

    checkOrderValidity() {
        if (this.isFlowAlreadyLaunched) {
            return;
        }
        this.isFlowAlreadyLaunched = true;
        if (!this.orderStatus) {
            console.log("order status should be retrieved");
            return;
        }
        if (this.orderStatus === ORDER_STATUS_ACTIVATED) {
            showValidationToast(this, `Order is already ${ORDER_STATUS_ACTIVATED}`);
            this.closeFlow();
            return;
        }
        this.externalSystemConfirmOrderSafe();
    }

    async externalSystemConfirmOrderSafe() {
        this.isOrderProcessing = true;
        try {
            await this.externalSystemConfirmOrder();
        } catch (e) {
            let errorMsg = parseApexException(e);
            showErrorToast(this, errorMsg);
        } finally {
            this.isOrderProcessing = false;
        }
    }

    async externalSystemConfirmOrder() {
        await apexPostOrder({
            orderId: this.recordId,
        });
        showSuccessToast(this, `Order is ${ORDER_STATUS_ACTIVATED}`);
        getRecordNotifyChange([{ recordId: this.recordId }]);
        this.closeFlow();
    }

    closeFlow() {
        const navigateNextEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateNextEvent);
    }
}
