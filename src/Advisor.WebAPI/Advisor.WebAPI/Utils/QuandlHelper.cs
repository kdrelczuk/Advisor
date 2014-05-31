using Newtonsoft.Json.Linq;
using QuandlCS.Requests;
using QuandlCS.Types;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;

namespace Advisor.WebAPI.Utils
{
    public static class QuandlHelper
    {
        private const string APIK_KEY = "QHkCyQxab8GwbAcKHPqE";

        private static HttpWebRequest CreateWebRequest(string endPoint)
        {
            var request = (HttpWebRequest)WebRequest.Create(endPoint);

            request.Method = "GET";
            request.ContentLength = 0;
            request.ContentType = "text/json";

            return request;
        }

        private static string GetMessage(string endPoint)
        {
            HttpWebRequest request = CreateWebRequest(endPoint);
            using (var response = (HttpWebResponse)request.GetResponse())
            {
                var responseValue = string.Empty;

                if (response.StatusCode != HttpStatusCode.OK)
                {
                    string message = String.Format("GET failed. Received HTTP {0}", response.StatusCode);
                    throw new ApplicationException(message);
                }

                // grab the response  
                using (var responseStream = response.GetResponseStream())
                {
                    using (var reader = new StreamReader(responseStream))
                    {
                        responseValue = reader.ReadToEnd();
                    }
                }

                return responseValue;
            }
        }

        private static string GetSingleData(string source, string code, DateTime start, Frequencies freq, Transformations trans)
        {
            QuandlDownloadRequest requestRawData = new QuandlDownloadRequest();
            requestRawData.APIKey = APIK_KEY;
            requestRawData.Datacode = new Datacode(source, code);
            requestRawData.Format = FileFormats.JSON;
            requestRawData.Frequency = freq;
            requestRawData.Transformation = trans;
            requestRawData.StartDate = start;
            requestRawData.EndDate = DateTime.Now;
            var urlRawData = requestRawData.ToRequestString();
            return GetMessage(urlRawData);
        }

        internal static List<QuandlStockResponse> GetData(string source, string code, DateTime? start, Frequencies freq)
        {
            List<QuandlStockResponse> result = new List<QuandlStockResponse>();
            if (!start.HasValue)
            {
                start = DateTime.Parse("1800-01-01");
            }

            var resRaw = GetSingleData(source, code, freq == Frequencies.Daily ? start.Value.AddDays(1) : start.Value, freq, Transformations.None);

            dynamic resParsedRaw = JValue.Parse(resRaw);

            for (int i = 0; i < resParsedRaw.data.Count; i++)
            {
                var elRaw = resParsedRaw.data[i];
                if ((elRaw[1] != null && elRaw[2] != null && elRaw[3] != null && elRaw[4] != null && elRaw[5] != null) &&
                    (elRaw[1] != 0 && elRaw[2] != 0 && elRaw[3] != 0 && elRaw[4] != 0))
                {
                    QuandlStockResponse r = new QuandlStockResponse();
                    r.Date = elRaw[0];
                    r.Open = elRaw[1];
                    r.High = elRaw[2];
                    r.Low = elRaw[3];
                    r.Close = elRaw[4];
                    r.Volume = elRaw[5];
                    result.Add(r);
                }
            }
            return result;
        }
    }
}