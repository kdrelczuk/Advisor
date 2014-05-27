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
                            bodyPadding: 10,
                            xtype : 'tickersdetailspanel',
                            closable: true
                        }
                    ).show();
                }
            }
        });
    }
});