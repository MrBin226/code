import scrapy
from selenium import webdriver
from wangyiPro.items import WangyiproItem


class WangyiSpider(scrapy.Spider):
    name = 'wangyi'
    # allowed_domains = ['www.com']
    start_urls = ['https://news.163.com/']
    model_urls = []  # 存储五大板块所对应的url

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.bro = webdriver.Edge()

    # 解析板块详情页新闻标题和对应的详情页url
    def parse_model(self, response):
        div_list = response.xpath('//div[@class="ndi_main"]/div')
        for div in div_list:
            if div.xpath('.//span[@class="tg_tag"]/text()').extract_first() == '广告':
                continue
            title = div.xpath('./div[@class="news_title"]/h3/a/text() | .//div[@class="news_title"]/h3/a/text()').extract_first()
            new_detail_url = div.xpath('./div[@class="news_title"]/h3/a/@href | .//div[@class="news_title"]/h3/a/@href').extract_first()
            print(title)
            print(new_detail_url)
            item = WangyiproItem()
            item["title"] = title
            # 对新闻详情页发起请求
            yield scrapy.Request(url=new_detail_url, callback=self.parse_detail, meta={"item": item})

    # 解析新闻内容
    def parse_detail(self, response):
        content = ''.join(response.xpath('//*[@id="content"]/div[2]//text() |'
                                         ' //div[@class="viewport"]//p/text()').extract())
        item = response.meta["item"]
        item["content"] = content
        yield item

    # 解析五大板块对应详情页的url
    def parse(self, response):
        li_list = response.xpath('//*[@id="index2016_wrap"]/div[1]/div[2]/div[2]/div[2]/div[2]/div/ul/li')
        alist = [3, 4, 6, 7, 8]
        for index in alist:
            model_url = li_list[index].xpath('./a/@href').extract_first()
            self.model_urls.append(model_url)

        # 依次对板块的url发起请求
        for url in self.model_urls:
            print(url)
            yield scrapy.Request(url=url, callback=self.parse_model)

    def closed(self, spider):
        self.bro.quit()

