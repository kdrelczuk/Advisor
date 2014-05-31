using Advisor.WebAPI.Models;
using Advisor.WebAPI.ServiceResponses;
using Advisor.WebAPI.ServiceResponses.TickerUpdate;
using Advisor.WebAPI.Utils;
using QuandlCS.Requests;
using QuandlCS.Types;
using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Advisor.WebAPI.Controllers
{
    public class TickerUpdateController : ApiController
    {

        #region API public methods

        // GET api/tickerupdate
        public BaseServiceResponse Get()
        {
            DateTime s1 = DateTime.Now;

            string[] tickersProceededNew = null;
            string[] tickersProceededDaily = null;
            string[] tickersProceededWeekly = null;
            string[] tickersProceededMonthly = null;

            using (var ctx = new AdvisorEntities())
            {
                ctx.Configuration.AutoDetectChangesEnabled = false;
                ctx.Configuration.ValidateOnSaveEnabled = false;

                int weekday = (int)DateTime.Now.DayOfWeek;
                DateTime datetTimeNow = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);

                // first update of a ticker
                var newTickers = ctx.Ticker.Where(p => !p.LastDailyUpdate.HasValue).ToList();
                if (newTickers.Any())
                {
                    tickersProceededNew = newTickers.Select(p => p.QuandlTicker).ToArray();
                    Iterate(ctx, newTickers, null);
                }

                var dailyTickers = ctx.Ticker.Where(p => p.LastDailyUpdate.Value < datetTimeNow).ToList();
                if (dailyTickers.Any())
                {
                    tickersProceededDaily = dailyTickers.Select(p => p.QuandlTicker).ToArray();
                    Iterate(ctx, dailyTickers, Frequencies.Daily);
                }

                var weeklyTickers = ctx.Ticker.Where(p => EntityFunctions.AddDays(p.LastWeeklyUpdate.Value, weekday) < datetTimeNow).ToList();
                if (weeklyTickers.Any())
                {
                    tickersProceededWeekly = weeklyTickers.Select(p => p.QuandlTicker).ToArray();
                    Iterate(ctx, weeklyTickers, Frequencies.Weekly);
                }

                var monthlyTickers = ctx.Ticker.Where(p => p.LastMonthlyUpdate.Value.Month != datetTimeNow.Month).ToList();
                if (monthlyTickers.Any())
                {
                    tickersProceededMonthly = monthlyTickers.Select(p => p.QuandlTicker).ToArray();
                    Iterate(ctx, monthlyTickers, Frequencies.Monthly);
                }
            }
            return new BaseServiceResponse()
            {
                Data = new TickerUpdateSimpleGetResponse()
                    {
                        ResponseTime = (DateTime.Now - s1).TotalSeconds.ToString(),
                        NewTickers = tickersProceededNew,
                        DailyTickers = tickersProceededDaily,
                        WeeklyTickers = tickersProceededWeekly,
                        MonthlyTikers = tickersProceededMonthly
                    }
            };
        }

        #endregion

        #region private methods

        private void Iterate(AdvisorEntities ctx, List<Ticker> tickers, Frequencies? frequencies)
        {
            foreach (var ticker in tickers)
            {
                var code = ticker.QuandlTicker.Split('/');
                var innerTicker = ctx.Ticker.Where(p => p.ID == ticker.ID).FirstOrDefault();
                var startDate = new DateTime(innerTicker.LastMonthlyUpdate.Value.Year, innerTicker.LastMonthlyUpdate.Value.Month, innerTicker.LastMonthlyUpdate.Value.Day);
                switch (frequencies)
                {
                    case Frequencies.Monthly:
                        {
                            ProceedWithMonthlyData(ctx, ticker, code, innerTicker, startDate);
                            break;
                        }
                    case Frequencies.Weekly:
                        {
                            ProceedWithWeeklyData(ctx, ticker, code, innerTicker, startDate);
                            break;
                        }
                    case Frequencies.Daily:
                        {
                            ProceedWithDailyData(ctx, ticker, code, innerTicker, startDate);
                            break;
                        }
                    case null:
                        {
                            ProceedWithDailyData(ctx, ticker, code, innerTicker, startDate);
                            ProceedWithWeeklyData(ctx, ticker, code, innerTicker, startDate);
                            ProceedWithMonthlyData(ctx, ticker, code, innerTicker, startDate);
                            break;
                        }
                }
                ctx.Entry(innerTicker).State = System.Data.EntityState.Modified;
                ctx.SaveChanges();
            }

        }

        #endregion

        #region EF helper methods

        private static void ProceedWithDailyData(AdvisorEntities ctx, Ticker ticker, string[] code, Ticker innerTicker, DateTime startDate)
        {
            List<QuandlStockResponse> data = QuandlHelper.GetData(code[0], code[1], startDate, Frequencies.Daily);
            AddDataDailyToContext(ctx, ticker, data);
            innerTicker.LastDailyUpdate = DateTime.Now;
        }

        private static void ProceedWithWeeklyData(AdvisorEntities ctx, Ticker ticker, string[] code, Ticker innerTicker, DateTime startDate)
        {
            List<QuandlStockResponse> data = QuandlHelper.GetData(code[0], code[1], startDate, Frequencies.Weekly);
            AddDataWeeklyToContext(ctx, ticker, data);
            innerTicker.LastWeeklyUpdate = DateTime.Now;
        }

        private static void ProceedWithMonthlyData(AdvisorEntities ctx, Ticker ticker, string[] code, Ticker innerTicker, DateTime startDate)
        {
            List<QuandlStockResponse> data = QuandlHelper.GetData(code[0], code[1], startDate, Frequencies.Monthly);
            AddDataMonthlyToContext(ctx, ticker, data);
            innerTicker.LastMonthlyUpdate = DateTime.Now;
        }

        private static void AddDataWeeklyToContext(AdvisorEntities ctx, Ticker ticker, List<QuandlStockResponse> data)
        {
            foreach (var el in data)
            {
                ctx.TickerWeeklyData.Add(new TickerWeeklyData
                {
                    Close = el.Close,
                    High = el.High,
                    Low = el.Low,
                    Open = el.Open,
                    Point = el.Date,
                    Ticker = ticker,
                    Volume = el.Volume
                });
            }
        }

        private static void AddDataMonthlyToContext(AdvisorEntities ctx, Ticker ticker, List<QuandlStockResponse> data)
        {
            foreach (var el in data)
            {
                ctx.TickerMonthlyData.Add(new TickerMonthlyData()
                {
                    Close = el.Close,
                    High = el.High,
                    Low = el.Low,
                    Open = el.Open,
                    Point = el.Date,
                    Ticker = ticker,
                    Volume = el.Volume
                });
            }
        }

        private static void AddDataDailyToContext(AdvisorEntities ctx, Ticker ticker, List<QuandlStockResponse> data)
        {
            foreach (var el in data)
            {
                ctx.TickerDailyData.Add(new TickerDailyData()
                {
                    Close = el.Close,
                    High = el.High,
                    Low = el.Low,
                    Open = el.Open,
                    Point = el.Date,
                    Ticker = ticker,
                    Volume = el.Volume
                });
            }
        }

        #endregion
    }
}
