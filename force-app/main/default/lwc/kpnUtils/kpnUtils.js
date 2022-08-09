
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
}

export {
    parseApexException,
};