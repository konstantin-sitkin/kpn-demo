import { ShowToastEvent } from "lightning/platformShowToastEvent";

const showValidationToast = (self, message) => {
    const evt = new ShowToastEvent({
        title: "Warning",
        message: message,
        variant: "warning",
    });
    self.dispatchEvent(evt);
};

const showSuccessToast = (self, message) => {
    const evt = new ShowToastEvent({
        title: "Success",
        message: message,
        variant: "success",
    });
    self.dispatchEvent(evt);
};

const showErrorToast = (self, message) => {
    const evt = new ShowToastEvent({
        title: "Error",
        message: message,
        variant: "error",
    });
    self.dispatchEvent(evt);
};

const parseApexException = (apexException) => {
    let returnErr;
    try {
        // common apex errors, trimmed for user
        returnErr = apexException?.body?.message || apexException?.body?.pageErrors[0].message;
    } catch (e) {
        // handle other cases
    }
    if (!returnErr) {
        returnErr = "Couldn't parse error response, see browser Inspector for details";
    }
    console.error(returnErr);
    return returnErr;
};

export { parseApexException, showErrorToast, showSuccessToast, showValidationToast };
