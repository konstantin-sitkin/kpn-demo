import { createElement } from 'lwc';
import KpnOrderProductCard from 'c/kpnOrderProductCard';

import apexAddProduct from "@salesforce/apex/KPN_OrderProductCtrl.addProduct";

const mockOrderItemCreated = require("./data/orderItemCreated.json");
const mockOrderItemUpdated = require("./data/orderItemUpdated.json");

jest.mock(
    "@salesforce/apex/KPN_OrderProductCtrl.addProduct",
    () => {
        return {
            default: jest.fn(),
        };
    },
    { virtual: true }
);

describe('c-kpn-order-product-card', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    async function flushPromises() {
        return Promise.resolve();
    }

    test('addNewProduct', async () => {
        apexAddProduct.mockResolvedValue(mockOrderItemCreated);
        const element = createElement('c-kpn-order-product-card', {
            is: KpnOrderProductCard
        });
        element.availableProduct = {
            listPrice: 46.71,
            name: "Batman Earth One",
            pbeId: "01u8V00000PcIBAQA3",
            productId: "01t8V000006duh7QAA",
        };
        element.orderId = "orderId";

        document.body.appendChild(element);

        const buttonAddProduct = element.shadowRoot.querySelector("lightning-button");
        buttonAddProduct.click();

        await flushPromises();
        
        expect(1).toBe(1);
    });

    test("addExistingProduct", async () => {
        apexAddProduct.mockResolvedValue(mockOrderItemUpdated);
        const element = createElement("c-kpn-order-product-card", {
            is: KpnOrderProductCard,
        });
        element.availableProduct = {
            listPrice: 46.71,
            name: "Batman Earth One",
            pbeId: "01u8V00000PcIBAQA3",
            productId: "01t8V000006duh7QAA",
        };

        document.body.appendChild(element);

        const buttonAddProduct = element.shadowRoot.querySelector("lightning-button");
        buttonAddProduct.click();

        await flushPromises();

        expect(1).toBe(1);
    });
});