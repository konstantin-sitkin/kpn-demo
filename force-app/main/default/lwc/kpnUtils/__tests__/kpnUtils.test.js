import { createElement } from "lwc";
import { parseApexException } from "c/kpnUtils";

describe("parseApexException", () => {
    it("should return default string", () => {
        expect(parseApexException(null)).not.toBeNull();
    });
});
