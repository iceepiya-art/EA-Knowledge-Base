import re
import requests
from html.parser import HTMLParser

class TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.text = []
        self.ignore_tags = {'script', 'style', 'noscript', 'meta', 'head', 'title'}
        self.current_tag = None
        self.skip_depth = 0

    def handle_starttag(self, tag, attrs):
        self.current_tag = tag
        if tag in self.ignore_tags:
            self.skip_depth += 1

    def handle_endtag(self, tag):
        if tag in self.ignore_tags:
            self.skip_depth = max(0, self.skip_depth - 1)
        self.current_tag = None

    def handle_data(self, data):
        if self.skip_depth == 0:
            clean_text = data.strip()
            if clean_text:
                self.text.append(clean_text)

    def get_text(self) -> str:
        return "\n\n".join(self.text)


def scrape_website_text(url: str, timeout: int = 20) -> str:
    """
    Fetches the HTML from a generic URL and extracts the visible text,
    stripping out scripts, styles, and markup.
    """
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
    }
    resp = requests.get(url, headers=headers, timeout=timeout)
    resp.raise_for_status()
    
    extractor = TextExtractor()
    extractor.feed(resp.text)
    
    raw_text = extractor.get_text()
    # Clean up excessive newlines
    clean_text = re.sub(r'\n{3,}', '\n\n', raw_text)
    return clean_text.strip()
