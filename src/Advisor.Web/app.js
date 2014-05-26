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
    views:
    [
      'TickersView',
      'DetailsView'
    ],
    launch: function()
    {
        Ext.create('Advisor.view.MainView')
    }
});