using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Advisor.WebAPI.ServiceResponses
{
    public class BaseServiceResponse
    {
        public object Data;
        public object SystemResponse = new { Version = "0.01", Responsed = DateTime.Now.ToString() };
    }
}