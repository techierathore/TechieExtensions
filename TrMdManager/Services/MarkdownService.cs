using Microsoft.JSInterop;

namespace TrMdManager.Services
{
    public interface IMarkdownService
    {
        string ConvertToHtml(string markdown);
        string ConvertToMarkdown(string html);
    }

    public class MarkdownService : IMarkdownService
    {
        private readonly IJSRuntime? _jsRuntime;

        public MarkdownService()
        {
        }
        
        public MarkdownService(IJSRuntime jsRuntime)
        {
            _jsRuntime = jsRuntime;
        }

        public string ConvertToHtml(string markdown)
        {
            if (string.IsNullOrEmpty(markdown))
                return string.Empty;
            
            // Normalize line endings
            markdown = markdown.Replace("\r\n", "\n").Replace("\r", "\n");
            var lines = markdown.Split('\n');
            var result = new System.Text.StringBuilder();
            
            var inCodeBlock = false;
            var inIndentedCode = false;
            var codeContent = new System.Text.StringBuilder();
            var codeLanguage = "";
            var inList = false;
            var listIndentLevel = 0;
            var inTable = false;
            var paragraphLines = new System.Collections.Generic.List<string>();
            var indentedCodeLines = new System.Collections.Generic.List<string>();
            var previousLineWasList = false;

            for (int i = 0; i < lines.Length; i++)
            {
                var line = lines[i];
                
                // Handle fenced code blocks (```)
                if (line.TrimEnd().StartsWith("```"))
                {
                    // Flush any pending content
                    if (indentedCodeLines.Count > 0)
                    {
                        FlushIndentedCode(result, indentedCodeLines);
                    }
                    FlushParagraph(result, paragraphLines);
                    CloseList(result, ref inList);
                    
                    if (!inCodeBlock)
                    {
                        // Starting a code block
                        inCodeBlock = true;
                        var marker = line.TrimEnd();
                        codeLanguage = marker.Length > 3 ? marker.Substring(3).Trim() : "";
                        codeContent.Clear();
                    }
                    else
                    {
                        // Ending a code block
                        inCodeBlock = false;
                        var escapedCode = System.Web.HttpUtility.HtmlEncode(codeContent.ToString());
                        result.AppendLine($"<pre><code class=\"language-{codeLanguage}\">{escapedCode}</code></pre>");
                        codeContent.Clear();
                        codeLanguage = "";
                    }
                    continue;
                }

                // If we're inside a fenced code block, just accumulate content
                if (inCodeBlock)
                {
                    if (codeContent.Length > 0)
                        codeContent.AppendLine();
                    codeContent.Append(line);
                    continue;
                }

                // Check for indented content
                int indentSpaces = 0;
                for (int j = 0; j < line.Length; j++)
                {
                    if (line[j] == ' ') indentSpaces++;
                    else if (line[j] == '\t') indentSpaces += 4;
                    else break;
                }
                
                bool isIndented = indentSpaces >= 4;
                
                // Determine if this is a code block or list continuation
                // Code blocks require 4+ spaces and NOT being in a list context
                // OR being in a list but with 8+ spaces (double indent)
                bool isCodeBlock = false;
                if (isIndented)
                {
                    if (!inList && !previousLineWasList)
                    {
                        // Not in list context, 4+ spaces = code block
                        isCodeBlock = true;
                    }
                    else if (inList && indentSpaces >= 8)
                    {
                        // In list context, need 8+ spaces for code block
                        isCodeBlock = true;
                    }
                    // Otherwise it's list continuation
                }
                
                if (isCodeBlock)
                {
                    // This is an indented code block line
                    if (paragraphLines.Count > 0)
                    {
                        FlushParagraph(result, paragraphLines);
                    }
                    
                    // Remove the appropriate indent (4 or 8 spaces)
                    var removeSpaces = inList ? 8 : 4;
                    var codeLine = line;
                    if (indentSpaces >= removeSpaces)
                    {
                        codeLine = line.Substring(Math.Min(removeSpaces, line.Length));
                    }
                    indentedCodeLines.Add(codeLine);
                    inIndentedCode = true;
                    continue;
                }
                else if (inIndentedCode && string.IsNullOrWhiteSpace(line))
                {
                    // Empty line in indented code block - keep accumulating
                    indentedCodeLines.Add("");
                    continue;
                }
                else if (inIndentedCode && !isCodeBlock)
                {
                    // End of indented code block
                    FlushIndentedCode(result, indentedCodeLines);
                    inIndentedCode = false;
                }

                // Process headers
                if (line.StartsWith("#"))
                {
                    FlushIndentedCode(result, indentedCodeLines);
                    FlushParagraph(result, paragraphLines);
                    CloseList(result, ref inList);
                    CloseTable(result, ref inTable);
                    
                    if (line.StartsWith("###### "))
                        result.AppendLine($"<h6>{ProcessInline(line.Substring(7))}</h6>");
                    else if (line.StartsWith("##### "))
                        result.AppendLine($"<h5>{ProcessInline(line.Substring(6))}</h5>");
                    else if (line.StartsWith("#### "))
                        result.AppendLine($"<h4>{ProcessInline(line.Substring(5))}</h4>");
                    else if (line.StartsWith("### "))
                        result.AppendLine($"<h3>{ProcessInline(line.Substring(4))}</h3>");
                    else if (line.StartsWith("## "))
                        result.AppendLine($"<h2>{ProcessInline(line.Substring(3))}</h2>");
                    else if (line.StartsWith("# "))
                        result.AppendLine($"<h1>{ProcessInline(line.Substring(2))}</h1>");
                    continue;
                }

                // Process lists
                var listMatch = System.Text.RegularExpressions.Regex.Match(line, @"^(\s*)([-*+]|\d+\.)\s+(.*)");
                if (listMatch.Success)
                {
                    FlushIndentedCode(result, indentedCodeLines);
                    FlushParagraph(result, paragraphLines);
                    CloseTable(result, ref inTable);
                    
                    var indent = listMatch.Groups[1].Value.Length;
                    
                    if (!inList)
                    {
                        var isOrdered = char.IsDigit(listMatch.Groups[2].Value[0]);
                        result.AppendLine(isOrdered ? "<ol>" : "<ul>");
                        inList = true;
                        listIndentLevel = indent;
                    }
                    
                    var content = listMatch.Groups[3].Value;
                    result.AppendLine($"<li>{ProcessInline(content)}</li>");
                    previousLineWasList = true;
                    continue;
                }
                else if (inList && !string.IsNullOrWhiteSpace(line) && indentSpaces < 2)
                {
                    // End of list if line is not indented at all
                    CloseList(result, ref inList);
                    listIndentLevel = 0;
                    previousLineWasList = false;
                }
                else if (inList && isIndented && !isCodeBlock)
                {
                    // This is list continuation content
                    // Just add it as part of the previous list item (already in a <li>)
                    result.AppendLine(ProcessInline(line.Trim()));
                    continue;
                }
                else
                {
                    previousLineWasList = false;
                }

                // Process blockquotes
                if (line.StartsWith(">"))
                {
                    FlushIndentedCode(result, indentedCodeLines);
                    FlushParagraph(result, paragraphLines);
                    CloseList(result, ref inList);
                    CloseTable(result, ref inTable);
                    
                    var quoteContent = line.Substring(1).TrimStart();
                    result.AppendLine($"<blockquote>{ProcessInline(quoteContent)}</blockquote>");
                    continue;
                }

                // Process horizontal rules
                var trimmedLine = line.Trim();
                if (trimmedLine == "---" || trimmedLine == "***" || trimmedLine == "___")
                {
                    FlushIndentedCode(result, indentedCodeLines);
                    FlushParagraph(result, paragraphLines);
                    CloseList(result, ref inList);
                    CloseTable(result, ref inTable);
                    result.AppendLine("<hr/>");
                    continue;
                }

                // Process tables
                if (line.Contains("|"))
                {
                    // Check if this is a separator line
                    if (System.Text.RegularExpressions.Regex.IsMatch(line, @"^\s*\|?\s*:?-+:?\s*(\|\s*:?-+:?\s*)*\|?\s*$"))
                    {
                        // Skip table separator
                        continue;
                    }
                    
                    FlushIndentedCode(result, indentedCodeLines);
                    FlushParagraph(result, paragraphLines);
                    CloseList(result, ref inList);
                    
                    if (!inTable)
                    {
                        result.AppendLine("<table>");
                        inTable = true;
                    }
                    
                    var cells = line.Split('|').Select(c => c.Trim()).ToArray();
                    if (cells.Length > 1)
                    {
                        result.Append("<tr>");
                        for (int j = 0; j < cells.Length; j++)
                        {
                            if (!string.IsNullOrEmpty(cells[j]) || (j > 0 && j < cells.Length - 1))
                            {
                                result.Append($"<td>{ProcessInline(cells[j])}</td>");
                            }
                        }
                        result.AppendLine("</tr>");
                    }
                    continue;
                }
                else if (inTable)
                {
                    CloseTable(result, ref inTable);
                }

                // Handle empty lines
                if (string.IsNullOrWhiteSpace(line))
                {
                    if (!inIndentedCode)
                    {
                        FlushIndentedCode(result, indentedCodeLines);
                        FlushParagraph(result, paragraphLines);
                    }
                    continue;
                }

                // Regular paragraph text
                if (!inIndentedCode)
                {
                    paragraphLines.Add(ProcessInline(line));
                }
            }

            // Handle any remaining content
            if (inCodeBlock && codeContent.Length > 0)
            {
                var escapedCode = System.Web.HttpUtility.HtmlEncode(codeContent.ToString());
                result.AppendLine($"<pre><code>{escapedCode}</code></pre>");
            }
            
            FlushIndentedCode(result, indentedCodeLines);
            FlushParagraph(result, paragraphLines);
            CloseList(result, ref inList);
            CloseTable(result, ref inTable);

            return result.ToString();
        }

        private void FlushIndentedCode(System.Text.StringBuilder result, System.Collections.Generic.List<string> lines)
        {
            if (lines.Count > 0)
            {
                // Remove trailing empty lines
                while (lines.Count > 0 && string.IsNullOrWhiteSpace(lines[lines.Count - 1]))
                {
                    lines.RemoveAt(lines.Count - 1);
                }
                
                if (lines.Count > 0)
                {
                    var code = string.Join("\n", lines);
                    var escapedCode = System.Web.HttpUtility.HtmlEncode(code);
                    result.AppendLine($"<pre><code>{escapedCode}</code></pre>");
                }
                lines.Clear();
            }
        }

        private void FlushParagraph(System.Text.StringBuilder result, System.Collections.Generic.List<string> lines)
        {
            if (lines.Count > 0)
            {
                result.AppendLine($"<p>{string.Join(" ", lines)}</p>");
                lines.Clear();
            }
        }

        private void CloseList(System.Text.StringBuilder result, ref bool inList)
        {
            if (inList)
            {
                // For now, we'll close with </ul> - ideally we'd track the list type
                result.AppendLine("</ul>");
                inList = false;
            }
        }

        private void CloseTable(System.Text.StringBuilder result, ref bool inTable)
        {
            if (inTable)
            {
                result.AppendLine("</table>");
                inTable = false;
            }
        }

        private string ProcessInline(string text)
        {
            if (string.IsNullOrEmpty(text))
                return "";

            // HTML encode first
            text = System.Web.HttpUtility.HtmlEncode(text);

            // Inline code (must come before other formatting)
            text = System.Text.RegularExpressions.Regex.Replace(text, @"`([^`]+)`", "<code>$1</code>");

            // Bold (must come before italic to handle ** vs *)
            text = System.Text.RegularExpressions.Regex.Replace(text, @"\*\*([^*]+)\*\*", "<strong>$1</strong>");
            text = System.Text.RegularExpressions.Regex.Replace(text, @"__([^_]+)__", "<strong>$1</strong>");

            // Italic
            text = System.Text.RegularExpressions.Regex.Replace(text, @"\*([^*]+)\*", "<em>$1</em>");
            text = System.Text.RegularExpressions.Regex.Replace(text, @"_([^_]+)_", "<em>$1</em>");

            // Links
            text = System.Text.RegularExpressions.Regex.Replace(text, @"\[([^\]]+)\]\(([^)]+)\)", 
                "<a href=\"$2\">$1</a>");

            // Images
            text = System.Text.RegularExpressions.Regex.Replace(text, @"!\[([^\]]*)\]\(([^)]+)\)", 
                "<img src=\"$2\" alt=\"$1\" />");

            return text;
        }

        public string ConvertToMarkdown(string html)
        {
            return html;
        }
    }
}