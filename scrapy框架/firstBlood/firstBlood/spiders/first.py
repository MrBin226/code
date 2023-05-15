import scrapy


class FirstSpider(scrapy.Spider):
    # 爬虫文件的名称，就是爬虫源文件的唯一标识
    name = 'first'
    # 允许的域名：用来限定start_urls列表中哪些url可以进行请求发送，通常情况下，这个参数被注释掉
    # allowed_domains = ['www.baidu.com']

    # 起始的URL列表：该列表中存放的url会被scrapy自动请求发送
    start_urls = ['http://www.baidu.com/', 'http://www.taobao.com']

    # 用于数据解析的函数：response表示请求成功后返回的响应对象
    def parse(self, response):
        print(response)
        pass
