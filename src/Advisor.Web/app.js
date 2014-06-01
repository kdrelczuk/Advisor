Ext.Loader.setConfig(
{
    enabled: true
});

Ext.application({
    name: 'Advisor',
    requires:
    [
        'Advisor.view.MainView'
    ],
    stores:
    [
        'TickersStore',
        'TickersDetailsChartStore'
    ],
    models:
    [
        'TickersModel',
        'TickersDetailsChartModel'
    ],
    views:
    [
      'TickersView',
      'DetailsView',
      'TickersDetailsView',
      'TickersDetailsChartView'
    ],
    controllers:
    [
        'Advisor.controller.TickersController',
        'Advisor.controller.TickersDetailsChartController'
    ],
    launch: function()
    {
        Ext.create('Advisor.view.MainView')
    }
});