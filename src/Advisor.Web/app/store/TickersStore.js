Ext.define('Advisor.store.TickersStore',
{
    extend: 'Ext.data.Store',
    model: 'Advisor.model.TickersModel',
    autoLoad: true,
    sorters:
    [
        {
            property: 'id'
        }
    ]
});