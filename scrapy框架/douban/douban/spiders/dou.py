import scrapy
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule
from douban.items import DoubanItem


class DouSpider(CrawlSpider):
    name = 'dou'
    # allowed_domains = ['www.com']
    start_urls = ['https://movie.douban.com/subject/35155748/comments?start=0&limit=20&sort=new_score&status=P&percent_type=']

    rules = (
        Rule(LinkExtractor(allow=r'https://movie.douban.com/subject/35155748/comments\?start=\d+&limit=20&sort='
                                 r'new_score&status=P&percent_type='), callback='parse_item', follow=True),
    )

    def parse_item(self, response):
        comment_items = response.xpath('//*[@id="comments"]/div[@class="comment-item "]')
        for comment_item in comment_items:
            item = DoubanItem()
            item["name"] = comment_item.xpath('.//span[@class="comment-info"]/a/text()').extract_first()
            item["time"] = comment_item.xpath('.//span[@class="comment-info"]/span[3]/@title').extract_first()
            item["score"] = comment_item.xpath('.//span[@class="comment-info"]/span[2]/@title').extract_first()
            item["content"] = ''.join(comment_item.xpath('.//p[@class=" comment-content"]//text()').extract())
            yield item
