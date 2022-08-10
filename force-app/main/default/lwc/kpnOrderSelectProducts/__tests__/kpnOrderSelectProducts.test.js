import { createElement } from 'lwc';
import KpnOrderSelectProducts from 'c/kpnOrderSelectProducts';

import { getRecord } from "lightning/uiRecordApi";

const mockGetRecord = require("./data/getRecord.json");
const mockProducts = require("./data/mockProducts.json");
const mockProductsCount = require("./data/mockProductsCount.json");

import apexGetOrderableProducts from "@salesforce/apex/KPN_OrderSelectProductsCtrl.getOrderableProducts";
import apexGetOrderableProductsCount from "@salesforce/apex/KPN_OrderSelectProductsCtrl.getOrderableProductsCount";

jest.mock(
    "@salesforce/apex/KPN_OrderSelectProductsCtrl.getOrderableProducts",
    () => {
        return {
            default: jest.fn(),
        };
    },
    { virtual: true }
);

jest.mock(
    "@salesforce/apex/KPN_OrderSelectProductsCtrl.getOrderableProductsCount",
    () => {
        return {
            default: jest.fn(),
        };
    },
    { virtual: true }
);

describe('c-kpn-order-select-products', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    async function flushPromises() {
        return Promise.resolve();
    }

    test('init select products', async () => {
        apexGetOrderableProducts.mockResolvedValue(mockProducts);
        apexGetOrderableProductsCount.mockResolvedValue(mockProductsCount);
        const element = createElement('c-kpn-order-select-products', {
            is: KpnOrderSelectProducts
        });
        document.body.appendChild(element);
        getRecord.emit(mockGetRecord);
        await flushPromises();
        expect(element.availableProducts).not.toBeNull();
    });

    test("pagination buttons", async () => {
        apexGetOrderableProducts.mockResolvedValue(mockProducts);
        apexGetOrderableProductsCount.mockResolvedValue(mockProductsCount);
        const element = createElement("c-kpn-order-select-products", {
            is: KpnOrderSelectProducts,
        });
        document.body.appendChild(element);
        getRecord.emit(mockGetRecord);
        await flushPromises();
        await flushPromises();
        expect(element.areProductsRendered).toBe(true);
        expect(element.previousDisabled).toBe(true);
        expect(element.nextDisabled).toBe(false);
        let paginationButtons = Object.values(element.shadowRoot.querySelectorAll('lightning-button'));
        const buttonNext = paginationButtons.find((button) => {return button.label === "Next"});
        buttonNext.click();
        await flushPromises();

        paginationButtons = Object.values(element.shadowRoot.querySelectorAll("lightning-button"));
        const buttonPrevious = paginationButtons.find((button) => {return !button.disabled && button.label === "Previous"});
        buttonPrevious.click();
        await flushPromises();

        expect(element.availableProducts).not.toBeNull();
    });
});