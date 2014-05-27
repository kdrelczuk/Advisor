Ext.define('Advisor.model.TickersModel',
{
    extend: 'Ext.data.Model',
    fields:
    [
        'id','name','price','change','pchange'
    ],
    proxy:
    {
        type: 'rest',
        url: 'data/tickersdata.json',
        reader:
        {
            type: 'json',
            root: 'data'
        }
    }
});