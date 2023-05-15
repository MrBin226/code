import scrapy


class XiaohuaSpider(scrapy.Spider):
    name = 'xiaohua'
    # allowed_domains = ['www.aa']
    start_urls = ['http://www.xiaohuar.com/daxue/']

    url = 'http://www.xiaohuar.com/daxue/index_%d.html'
    page_num = 1

    def parse(self, response):
        photo_name = response.xpath('//div[@class="col-md-6 col-lg-3"]//img/@alt').extract()
        for i in photo_name:
            print(i)
        self.page_num += 1
        new_url = format(self.url % self.page_num)
        if self.page_num < 11:
            # 手动请求发送：
            yield scrapy.Request(url=new_url, callback=self.parse)
