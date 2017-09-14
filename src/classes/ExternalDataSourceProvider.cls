/**
 * Created by rsieve on 8/17/17.
 */

public with sharing class ExternalDataSourceProvider extends Datasource.Provider{
    override public List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        List<DataSource.AuthenticationCapability> capabilities =
                new List<DataSource.AuthenticationCapability>();
        capabilities.add(
                DataSource.AuthenticationCapability.OAUTH);
        capabilities.add(
                DataSource.AuthenticationCapability.ANONYMOUS);
        capabilities.add(
                DataSource.AuthenticationCapability.BASIC);
        capabilities.add(
                DataSource.AuthenticationCapability.CERTIFICATE);
        return capabilities;
    }
    override public List<DataSource.Capability> getCapabilities() {
        List<DataSource.Capability> capabilities = new
                List<DataSource.Capability>();
        capabilities.add(DataSource.Capability.ROW_QUERY);
        capabilities.add(DataSource.Capability.SEARCH);
        return capabilities;
    }
    override public DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams) {
        return new ExternalDataSourceConnection(connectionParams);
    }
}