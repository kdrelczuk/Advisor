Ext.define('Advisor.view.DetailsView',
    {
        extend: 'Ext.tab.Panel',
        alias: 'widget.detailspanel',
        id: 'tabs',
        items: [
            {
                title: 'Welcome',
                html : 'Hello!'
            },
            {
                title: 'Tab 2',
                html : 'Another one',
                closable: true
            }
        ]
    });