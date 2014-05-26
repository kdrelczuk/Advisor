Ext.define('Advisor.view.MainView',
    {
        extend: 'Ext.container.Viewport',
        layout:
        {
            type: 'hbox',
            align: 'stretch',
        },
        items: [
                    {
                        xtype: 'tickerspanel',
                        width: 400
                    },
                    {
                        xtype: 'splitter'
                    },
                    {
                        xtype: 'detailspanel',
                        flex: 12,
                        region: 'east',
                        split: true
                    }
                ]
    });