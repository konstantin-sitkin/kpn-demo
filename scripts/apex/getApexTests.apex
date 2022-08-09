List<TestSuiteMembership> apexTests = [
    SELECT Id, ApexTestSuiteId, ApexClass.Name FROM TestSuiteMembership
    WHERE ApexTestSuite.TestSuiteName = 'KPN'
];
List<String> apexTestNames = new List<String>();
for (TestSuiteMembership apexTest : apexTests) {
    apexTestNames.add(apexTest.ApexClass.Name);
}
System.debug(String.join(apexTestNames, ','));

