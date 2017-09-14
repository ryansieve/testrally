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

        //Sample Invoice Line Table
        List<DataSource.Column> lineColumns = new List<DataSource.Column>();
        lineColumns.add(DataSource.Column.text('ExternalId', 255));
        lineColumns.add(DataSource.Column.url('DisplayUrl'));
        lineColumns.add(DataSource.Column.ExternalLookup('Invoice', 'Invoice__x'));
        lineColumns.add(DataSource.Column.IndirectLookup('Product','Product2', 'ExtId__c'));
        lineColumns.add(DataSource.Column.get('Quantity', 'Quantity', 'Quantity', false, false, DataSource.DataType.NUMBER_TYPE, 12, 2));
        lineColumns.add(DataSource.Column.get('UnitPrice', 'Unit Price', 'Unit Price', false, false, DataSource.DataType.NUMBER_TYPE, 12, 2));
        lineColumns.add(DataSource.Column.get('ExtendedPrice', 'Extended Price', 'Extended Price', false, false, DataSource.DataType.NUMBER_TYPE, 12, 2));
        tables.add(DataSource.Table.get('Invoice_Line', 'ExternalId', lineColumns));

        return tables;
    }

    override public DataSource.TableResult query(DataSource.QueryContext context) {

        long past = System.currentTimeMillis();
        String table = context.tableSelection.tableSelected;
        DataSource.TableResult result;
        system.debug('table: ' + table);
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        
        if(table == 'Invoice'){

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
        }else if(table == 'Invoice_Line'){

            //Invoice__x inv = null;//[SELECT Id, ExternalId FROM Invoice__x LIMIT 1];
            List<Product2> prods = [SELECT Id, Name, ExtId__c
                                        FROM Product2
                                        WHERE IsActive = true
                                        AND ExtId__c != null
                                        ORDER BY Name LIMIT 2];

            Map<String, Object> row1 = new Map<String, Object>();
            row1.put('ExternalId', 'DB7Q1311ND-1');
            row1.put('DisplayUrl', 'https://www.google.com');
            row1.put('Product', prods[0].ExtId__c);
            row1.put('Quantity', 2);
            row1.put('UnitPrice', 450);
            row1.put('ExtendedPrice', 900);
            row1.put('Invoice', 'DB7Q1311ND');
            rows.add(row1);

            Map<String, Object> row2 = new Map<String, Object>();
            row2.put('ExternalId', 'DB7Q1311ND-2');
            row2.put('DisplayUrl', 'https://www.google.com');
            row2.put('Product', prods[1].ExtId__c);
            row2.put('Quantity', 1);
            row2.put('UnitPrice', 300);
            row2.put('ExtendedPrice', 300);
            row2.put('Invoice', 'DB7Q1311ND');
            rows.add(row2);
        }

        system.debug(JSON.serialize(rows));

        result = DataSource.TableResult.get(true, null, context.tableSelection.tableSelected, rows);

        long now = System.currentTimeMillis();
        system.debug('DATA SOURCE PROVIDER TIME: ' + (now - past));

        system.debug('US10 comment');

        return result;
    }

    override public List<DataSource.TableResult> search(DataSource.SearchContext contexts) {
        return null;
    }
}