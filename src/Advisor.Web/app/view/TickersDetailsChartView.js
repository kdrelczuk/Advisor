Ext.define('Advisor.view.TickersDetailsChartView',
{
    extend: 'Ext.panel.Panel',
    alias: 'widget.tickersdetailschartpanel',
    html: 'ddddddddddd',
    listeners:
    {
        resize: function (panel, width, height, oldWidth, oldHeight, eOpts )
        {
            /* url = 'http://localhost:18880/custom/getdata?id=GOOG/NASDAQ_MSFT&x='+width+'&y='+height;
             Ext.Ajax.request(
             {
             url: url,
             success: function(data){
             // handler
             console.log('OK')
             },
             failure: function(){
             // handler
             console.log('OK')
             }
             });*/
        }
    }
});