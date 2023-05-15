import scrapy
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule


class SunSpider(CrawlSpider):
    name = 'sun'
    # allowed_domains = ['www.com']
    start_urls = ['http://wz.sun0769.com/political/index/politicsNewest']

    # 链接提取器：根据指定规则（allow=“正则表达式”）进行指定链接的提取
    link = LinkExtractor(allow=r'id=1&page=\d+')

    rules = (
        # 规则解析器：将链接提取器提取到的链接进行指定规则的解析
        Rule(link, callback='parse_item', follow=True),
    )

    def parse_item(self, response):
        print(response)
