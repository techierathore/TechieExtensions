using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Text;

namespace TrJsonManager.Services
{
    public interface IJsonService
    {
        JsonValidationResult ValidateJson(string jsonText);
        string FormatJson(string jsonText, bool minify = false);
        string MinifyJson(string jsonText);
        string ConvertToXml(string jsonText);
        string ConvertToCsv(string jsonText);
        JsonTreeNode? BuildTreeView(string jsonText);
    }

    public class JsonService : IJsonService
    {
        public JsonValidationResult ValidateJson(string jsonText)
        {
            var result = new JsonValidationResult();
            
            if (string.IsNullOrWhiteSpace(jsonText))
            {
                result.IsValid = false;
                result.ErrorMessage = "JSON is empty";
                return result;
            }

            try
            {
                var token = JToken.Parse(jsonText);
                result.IsValid = true;
                result.ParsedJson = token;
                
                // Get statistics
                result.Statistics = new JsonStatistics
                {
                    TotalKeys = CountKeys(token),
                    TotalValues = CountValues(token),
                    Depth = GetDepth(token),
                    ArrayCount = CountArrays(token),
                    ObjectCount = CountObjects(token)
                };
            }
            catch (JsonReaderException ex)
            {
                result.IsValid = false;
                result.ErrorMessage = $"Invalid JSON: {ex.Message}";
                result.ErrorLine = ex.LineNumber;
                result.ErrorPosition = ex.LinePosition;
            }
            catch (Exception ex)
            {
                result.IsValid = false;
                result.ErrorMessage = $"Error parsing JSON: {ex.Message}";
            }

            return result;
        }

        public string FormatJson(string jsonText, bool minify = false)
        {
            try
            {
                var token = JToken.Parse(jsonText);
                return minify 
                    ? token.ToString(Formatting.None) 
                    : token.ToString(Formatting.Indented);
            }
            catch
            {
                return jsonText;
            }
        }

        public string MinifyJson(string jsonText)
        {
            return FormatJson(jsonText, true);
        }

        public string ConvertToXml(string jsonText)
        {
            try
            {
                var token = JToken.Parse(jsonText);
                var xml = JsonConvert.DeserializeXNode("{\"root\":" + token.ToString() + "}", "root");
                return xml?.ToString() ?? string.Empty;
            }
            catch
            {
                return string.Empty;
            }
        }

        public string ConvertToCsv(string jsonText)
        {
            try
            {
                var token = JToken.Parse(jsonText);
                if (token is JArray array)
                {
                    return ConvertArrayToCsv(array);
                }
                return "JSON must be an array to convert to CSV";
            }
            catch
            {
                return string.Empty;
            }
        }

        public JsonTreeNode? BuildTreeView(string jsonText)
        {
            try
            {
                var token = JToken.Parse(jsonText);
                return BuildNode("root", token);
            }
            catch
            {
                return null;
            }
        }

        private JsonTreeNode BuildNode(string name, JToken token)
        {
            var node = new JsonTreeNode
            {
                Name = name,
                Type = token.Type.ToString(),
                Path = token.Path
            };

            switch (token.Type)
            {
                case JTokenType.Object:
                    node.Value = "{...}";
                    node.Children = new List<JsonTreeNode>();
                    foreach (var property in token.Children<JProperty>())
                    {
                        node.Children.Add(BuildNode(property.Name, property.Value));
                    }
                    break;
                    
                case JTokenType.Array:
                    node.Value = $"[{token.Children().Count()}]";
                    node.Children = new List<JsonTreeNode>();
                    int index = 0;
                    foreach (var item in token.Children())
                    {
                        node.Children.Add(BuildNode($"[{index}]", item));
                        index++;
                    }
                    break;
                    
                default:
                    node.Value = token.ToString();
                    break;
            }

            return node;
        }

        private string ConvertArrayToCsv(JArray array)
        {
            if (array.Count == 0) return string.Empty;

            var csv = new StringBuilder();
            var headers = new HashSet<string>();

            // Get all unique headers
            foreach (var item in array)
            {
                if (item is JObject obj)
                {
                    foreach (var prop in obj.Properties())
                    {
                        headers.Add(prop.Name);
                    }
                }
            }

            // Write headers
            csv.AppendLine(string.Join(",", headers));

            // Write data
            foreach (var item in array)
            {
                if (item is JObject obj)
                {
                    var values = headers.Select(h => 
                    {
                        var val = obj[h]?.ToString() ?? "";
                        return val.Contains(",") ? $"\"{val}\"" : val;
                    });
                    csv.AppendLine(string.Join(",", values));
                }
            }

            return csv.ToString();
        }

        private int CountKeys(JToken token)
        {
            int count = 0;
            if (token is JObject obj)
            {
                count += obj.Properties().Count();
                foreach (var child in obj.Children())
                {
                    count += CountKeys(child);
                }
            }
            else if (token is JArray array)
            {
                foreach (var child in array)
                {
                    count += CountKeys(child);
                }
            }
            return count;
        }

        private int CountValues(JToken token)
        {
            int count = 0;
            switch (token.Type)
            {
                case JTokenType.String:
                case JTokenType.Integer:
                case JTokenType.Float:
                case JTokenType.Boolean:
                case JTokenType.Null:
                    return 1;
                case JTokenType.Object:
                    foreach (var child in token.Children())
                    {
                        count += CountValues(child);
                    }
                    break;
                case JTokenType.Array:
                    foreach (var child in token.Children())
                    {
                        count += CountValues(child);
                    }
                    break;
            }
            return count;
        }

        private int GetDepth(JToken token, int currentDepth = 0)
        {
            if (token is JObject obj)
            {
                if (!obj.HasValues) return currentDepth;
                return obj.Properties().Max(p => GetDepth(p.Value, currentDepth + 1));
            }
            else if (token is JArray array)
            {
                if (array.Count == 0) return currentDepth;
                return array.Max(item => GetDepth(item, currentDepth + 1));
            }
            return currentDepth;
        }

        private int CountArrays(JToken token)
        {
            int count = token.Type == JTokenType.Array ? 1 : 0;
            foreach (var child in token.Children())
            {
                count += CountArrays(child);
            }
            return count;
        }

        private int CountObjects(JToken token)
        {
            int count = token.Type == JTokenType.Object ? 1 : 0;
            foreach (var child in token.Children())
            {
                count += CountObjects(child);
            }
            return count;
        }
    }

    public class JsonValidationResult
    {
        public bool IsValid { get; set; }
        public string? ErrorMessage { get; set; }
        public int? ErrorLine { get; set; }
        public int? ErrorPosition { get; set; }
        public JToken? ParsedJson { get; set; }
        public JsonStatistics? Statistics { get; set; }
    }

    public class JsonStatistics
    {
        public int TotalKeys { get; set; }
        public int TotalValues { get; set; }
        public int Depth { get; set; }
        public int ArrayCount { get; set; }
        public int ObjectCount { get; set; }
    }

    public class JsonTreeNode
    {
        public string Name { get; set; } = string.Empty;
        public string Value { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
        public string Path { get; set; } = string.Empty;
        public List<JsonTreeNode>? Children { get; set; }
        public bool IsExpanded { get; set; } = false;
    }
}