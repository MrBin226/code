import scrapy
from imgsPro.items import ImgsproItem

class ImgsSpider(scrapy.Spider):
    name = 'imgs'
    # allowed_domains = ['www.com']
    start_urls = ['https://sc.chinaz.com/tupian/mingxingtupian.html']

    def parse(self, response):
        img_urls = response.xpath('//div[@id="container"]//a//img/@src2').extract()
        for img_url in img_urls:
            item = ImgsproItem()
            item['src'] = img_url
            yield item
