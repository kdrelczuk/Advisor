//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Advisor.WebAPI.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Ticker
    {
        public Ticker()
        {
            this.TickerDailyData = new HashSet<TickerDailyData>();
            this.TickerMonthlyData = new HashSet<TickerMonthlyData>();
            this.TickerWeeklyData = new HashSet<TickerWeeklyData>();
        }
    
        public short ID { get; set; }
        public string ShortName { get; set; }
        public string LongName { get; set; }
        public string Market { get; set; }
        public string QuandlTicker { get; set; }
        public Nullable<System.DateTime> LastDailyUpdate { get; set; }
        public Nullable<System.DateTime> LastWeeklyUpdate { get; set; }
        public Nullable<System.DateTime> LastMonthlyUpdate { get; set; }
    
        public virtual ICollection<TickerDailyData> TickerDailyData { get; set; }
        public virtual ICollection<TickerMonthlyData> TickerMonthlyData { get; set; }
        public virtual ICollection<TickerWeeklyData> TickerWeeklyData { get; set; }
    }
}
