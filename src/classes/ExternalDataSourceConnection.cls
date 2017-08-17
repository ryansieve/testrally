/**
 * Created by rsieve on 8/17/17.
 */

public with sharing class ExternalDataSourceConnection  extends DataSource.Connection {
    private DataSource.ConnectionParams connectionInfo;
    public ExternalDataSourceConnection(DataSource.ConnectionParams connectionInfo) {
        this.connectionInfo = connectionInfo;
    }

    override public List<DataSource.Table> sync() {
        List<DataSource.Table> tables = new List<DataSource.Table>();

        //Sample Invoice Table
        List<DataSource.Column> columns = new List<DataSource.Column>();
        columns.add(DataSource.Column.text('ExternalId', 255));
        columns.add(DataSource.Column.url('DisplayUrl'));
        columns.add(DataSource.Column.indirectLookup('Account','Account', 'ExtId__c'));
        columns.add(DataSource.Column.get('InvoiceDate', 'Invoice Date', 'Invoice Date', false, true, DataSource.DataType.DATETIME_TYPE, 30));
        columns.add(DataSource.Column.get('DueDate', 'Due Date', 'Due Date', false, true, DataSource.DataType.DATETIME_TYPE, 30));
        columns.add(DataSource.Column.get('AmountDue', 'Amount Due', 'Amount Due', false, false, DataSource.DataType.NUMBER_TYPE, 12, 2));
        columns.add(DataSource.Column.get('AmountPaid', 'Amount Paid', 'Amount Paid', false, false, DataSource.DataType.NUMBER_TYPE, 12, 2));
        columns.add(DataSource.Column.get('Total', 'Total', 'Total', false, false, DataSource.DataType.NUMBER_TYPE, 12, 2));
        columns.add(DataSource.Column.text('Currency', 3));
        tables.add(DataSource.Table.get('Invoice', 'ExternalId', columns));
        return tables;
    }

    override public DataSource.TableResult query(DataSource.QueryContext context) {

        long past = System.currentTimeMillis();
        String table = context.tableSelection.tableSelected;
        DataSource.TableResult result;


        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        Map<String, Object> row1 = new Map<String, Object>();
        row1.put('ExternalId', 'DB7Q1311ND');
        row1.put('DisplayUrl', 'https://www.google.com');
        row1.put('Account', 'BTXT');
        row1.put('InvoiceDate', DateTime.newInstance(2017, 2, 23, 12, 0, 0));
        row1.put('DueDate', DateTime.newInstance(2017, 3, 31, 12, 0, 0));
        row1.put('AmountDue', 0);
        row1.put('AmountPaid', 1200);
        row1.put('Total', 1200);
        row1.put('Currency', 'USD');

        rows.add(row1);

        result = DataSource.TableResult.get(true, null, context.tableSelection.tableSelected, rows);

        long now = System.currentTimeMillis();
        system.debug('DATA SOURCE PROVIDER TIME: ' + (now - past));
        return result;
    }

    override public List<DataSource.TableResult> search(DataSource.SearchContext contexts) {
        return null;
    }
}