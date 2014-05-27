Ext.define('Advisor.model.TickersDetailsChartModel',
{
    extend: 'Ext.data.Model',
    fields:
        [
            'charturl','perf'
        ],
    proxy:
    {
        type: 'rest',
        url: 'http://localhost:18880/custom/getdata?id=GOOG/NASDAQ_MSFT&x=1200&y=800',
        reader:
        {
            type: 'json',
            root: 'data'
        }
    }
});