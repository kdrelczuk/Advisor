Ext.define('Advisor.controller.TickersController',
{
    extend: 'Ext.app.Controller',

    init: function()
    {
        this.control(
        {
            'tickerspanel':
            {
                itemdblclick: function(gridpanel,record,item,e)
                {
                    var tabPanel = Ext.getCmp('tabs');
                    tabPanel.add(
                        {
                            title: record.data.id,
                            border:true,
                            xtype : 'tickersdetailspanel',
                            closable: true,
                            ticker: 'T_' + record.data.id
                        }
                    ).show();
                }
            }
        });
    }
});