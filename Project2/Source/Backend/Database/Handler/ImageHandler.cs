using System;
using System.IO;
using Backend.Database.Dtos;

namespace Backend.Database.Handler
{
    public static class ImageHandler
    {
        public static ImageDto GetProductImage(string path)
        {
            try
            {
                byte[] content = File.ReadAllBytes("Resource/" + path);
                return new ImageDto() 
                {
                    ContentType = "image/png",
                    Content = content
                };
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
    
}
