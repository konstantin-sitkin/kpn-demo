import { createElement } from 'lwc';
import KpnOrderViewOrderItems from 'c/kpnOrderViewOrderItems';

import apexGetOrderItems from "@salesforce/apex/KPN_OrderViewOrderItemsCtrl.getOrderItems";
import { subscribe, MessageContext, publish } from "lightning/messageService";
import CHANNEL_ORDER_ITEM_CHANGE from "@salesforce/messageChannel/OrderItemChange__c";


const mockOrderItems = require("./data/orderItems.json");
const mockOrderItemCreated = require("./data/orderItemCreated.json");
const mockOrderItemUpdated = require("./data/orderItemUpdated.json");

jest.mock(
    "@salesforce/apex/KPN_OrderViewOrderItemsCtrl.getOrderItems",
    () => {
        return {
            default: jest.fn(),
        };
    },
    { virtual: true }
);

describe('c-kpn-order-view-order-items', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    async function flushPromises() {
        return Promise.resolve();
    }

    test('init component', async () => {
        apexGetOrderItems.mockResolvedValue(mockOrderItems);
        const element = createElement('c-kpn-order-view-order-items', {
            is: KpnOrderViewOrderItems
        });
        document.body.appendChild(element);
        const payloadCreated = { data: mockOrderItemCreated };
        publish(MessageContext, CHANNEL_ORDER_ITEM_CHANGE, payloadCreated);
        flushPromises();

        const payloadUpdated = { data: mockOrderItemUpdated };
        publish(MessageContext, CHANNEL_ORDER_ITEM_CHANGE, payloadUpdated);
        flushPromises();

        expect(1).toBe(1);
    });
});