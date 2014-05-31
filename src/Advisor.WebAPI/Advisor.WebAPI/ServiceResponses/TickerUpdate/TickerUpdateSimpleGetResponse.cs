using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Advisor.WebAPI.ServiceResponses.TickerUpdate
{
    public class TickerUpdateSimpleGetResponse
    {
        public string ResponseTime { get; set; }
        public string[] NewTickers { get; set; }
        public string[] DailyTickers { get; set; }
        public string[] WeeklyTickers { get; set; }
        public string[] MonthlyTikers { get; set; }
    }
}