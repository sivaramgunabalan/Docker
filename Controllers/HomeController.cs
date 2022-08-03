using Application.Connect.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Syncfusion.HtmlConverter;
using Syncfusion.Pdf;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Application.Connect.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public IActionResult ExportToPDF()
        {
            //Initialize HTML to PDF converter with Blink rendering engine
            HtmlToPdfConverter htmlConverter = new HtmlToPdfConverter(HtmlRenderingEngine.Blink);

            BlinkConverterSettings settings = new BlinkConverterSettings();

            settings.BlinkPath = Path.Combine("BlinkBinariesLinux");

            settings.CommandLineArguments.Add("--no-sandbox");

            settings.CommandLineArguments.Add("--disable-setuid-sandbox");

            htmlConverter.ConverterSettings = settings;

            PdfDocument document = htmlConverter.Convert("https://www.google.com");

            MemoryStream stream = new MemoryStream();

            document.Save(stream);

            stream.Position = 0;

            return File(stream.ToArray(), System.Net.Mime.MediaTypeNames.Application.Pdf, "Sample.pdf");
        }
    }
}
