using GrpcDemoService.Services;
using Microsoft.OpenApi.Models;

namespace GrpcDemoService
{
    /// <summary>
    /// Represents the main class of the application responsible for bootstrapping and configuring the web server.
    /// </summary>
    public class Program
    {
        /// <summary>
        /// The entry point of the application.
        /// </summary>
        /// <param name="args">The command-line arguments passed to the application.</param>
        public static void Main(string[] args)
        {
            // test
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddGrpc().AddJsonTranscoding();
            builder.Services.AddGrpcReflection();

            builder.Services.AddGrpcSwagger();
            builder.Services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1",
                    new OpenApiInfo 
                    { 
                        Title = "gRPC Demo Service", 
                        Version = "v1",
                        Description = "A simple .NET 8 gRPC Service Demo",
                        Contact = new OpenApiContact
                        {
                            Name = "Your Name",
                            Url = new System.Uri("https://asp.net")
                        }
                    });

                var filePath = Path.Combine(AppContext.BaseDirectory, $"{typeof(Program).Namespace}.xml");

                c.IncludeXmlComments(filePath);
                c.IncludeGrpcXmlComments(filePath, includeControllerXmlComments: true);
            });

            var app = builder.Build();

            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "gRPC Demo Service v1");
            });

            app.MapGrpcService<GreeterService>();
            app.MapGrpcReflectionService();

            app.Run();
        }
    }
}