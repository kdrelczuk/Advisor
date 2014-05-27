Ext.define('Advisor.view.TickersView',
    {
        extend: 'Ext.grid.Panel',
        alias: 'widget.tickerspanel',
        store: 'TickersStore',
        columns:
        [
            {
                xtype: 'gridcolumn',
                text: 'Ticker',
                dataIndex: 'id',
                width: 60,
                filterable: true
            },
            {
                xtype: 'gridcolumn',
                text: 'Company name',
                dataIndex: 'name',
                flex: 1,
                filter: {
                    type: 'string'
                    // specify disabled to disable the filter menu
                    //, disabled: true
                }
            },
            {
                text: 'Value',
                columns:
                [
                    {
                        xtype: 'gridcolumn',
                        text: 'Price',
                        align: 'right',
                        dataIndex: 'price',
                        width: 65
                    },
                    {
                        xtype: 'gridcolumn',
                        text: 'Change',
                        align: 'right',
                        dataIndex: 'change',
                        width: 65,
                        renderer :  function(val) {
                            if (val > 0) {
                                return '<span style="color:green;">' + val + '</span>';
                            } else if (val < 0) {
                                return '<span style="color:red;">' + val + '</span>';
                            }
                            return val;
                        }
                    },
                    {
                        xtype: 'gridcolumn',
                        text: '% change',
                        align: 'right',
                        dataIndex: 'pchange',
                        width: 65,
                        renderer :  function(val) {
                            if (val > 0) {
                                return '<span style="color:green;">' + val + '</span>';
                            } else if (val < 0) {
                                return '<span style="color:red;">' + val + '</span>';
                            }
                            return val;
                        }
                    }
                ]
            }
        ]
    }
);