using Markdig;
using Markdig.Extensions.Tables;
using Markdig.Extensions.TaskLists;
using Markdig.Extensions.Emoji;

namespace TrMdManager.Services
{
    public interface IMarkdownService
    {
        string ConvertToHtml(string markdown);
        string ConvertToMarkdown(string html);
    }

    public class MarkdownService : IMarkdownService
    {
        private readonly MarkdownPipeline _pipeline;

        public MarkdownService()
        {
            _pipeline = new MarkdownPipelineBuilder()
                .UseAdvancedExtensions()
                .UseEmojiAndSmiley()
                .UseTaskLists()
                .UsePipeTables()
                .UseGridTables()
                .UseAutoLinks()
                .Build();
        }

        public string ConvertToHtml(string markdown)
        {
            if (string.IsNullOrEmpty(markdown))
                return string.Empty;

            return Markdown.ToHtml(markdown, _pipeline);
        }

        public string ConvertToMarkdown(string html)
        {
            return html;
        }
    }
}