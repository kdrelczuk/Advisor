using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Advisor.WebAPI.Utils
{
    public class QuandlStockResponse
    {
        public DateTime Date { get; set; }
        public decimal Open { get; set; }
        public decimal High { get; set; }
        public decimal Low { get; set; }
        public decimal Close { get; set; }
        public int Volume { get; set; }
    }
}