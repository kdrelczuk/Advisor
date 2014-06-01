Ext.define('Advisor.view.TickersDetailsView',
    {
        extend: 'Ext.tab.Panel',
        alias: 'widget.tickersdetailspanel',
        items: [
            {
                title: 'Basic charts',
                xtype: 'tickersdetailschartpanel'
            }
        ]
    });
