const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');

module.exports = {
    ...jestConfig,
    modulePathIgnorePatterns: ["<rootDir>/.localdevserver"],
    moduleNameMapper: {
        "^lightning/messageService$": "<rootDir>/force-app/test/jest-mocks/lightning/messageService",
    },
};
