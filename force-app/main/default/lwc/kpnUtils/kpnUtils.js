
const parseApexException = (apexException) => {
    let returnErr;
    try {
        returnErr = apexException?.body?.message || apexException?.body?.pageErrors[0].message;
    } catch (e) {
        // handle other cases
    }
    if (!returnErr) {
        returnErr = this.labels.couldntParseResponse;
    }
    console.error(returnErr);
    return returnErr;
}

export {
    parseApexException,
};