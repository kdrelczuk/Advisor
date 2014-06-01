Ext.define('Advisor.controller.TickersDetailsChartController',
    {
        extend: 'Ext.app.Controller',
        init: function()
        {
            this.control(
                {
                    'tickersdetailschartpanel':
                    {
                        boxready: function (panel, width, height, eOpts )
                        {
                            var ticker = panel.up().ticker;
                            var url = 'http://192.168.0.29/plot_id1_nameMSTF_x1000_y660_pstart2006-02-01_pstop2011-01-01.png';
                            console.log(url);
                            panel.update({url:url});
                        }
                    }
                });
        }
    });