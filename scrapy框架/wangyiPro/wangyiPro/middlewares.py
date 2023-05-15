# Define here the models for your spider middleware
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/spider-middleware.html

from scrapy import signals
from scrapy.http import HtmlResponse
from time import sleep

# useful for handling different item types with a single interface
from itemadapter import is_item, ItemAdapter


class WangyiproDownloaderMiddleware:
    # Not all methods need to be defined. If a method is not defined,
    # scrapy acts as if the downloader middleware does not modify the
    # passed objects.

    def process_request(self, request, spider):
        # Called for each request that goes through the downloader
        # middleware.

        # Must either:
        # - return None: continue processing this request
        # - or return a Response object
        # - or return a Request object
        # - or raise IgnoreRequest: process_exception() methods of
        #   installed downloader middleware will be called
        return None

    # 会拦截任何响应对象，进行篡改
    def process_response(self, request, response, spider):
        # 挑选出指定的响应对象进行篡改
        # 通过url指定request
        # 通过request指定response
        # spider表示爬虫对象
        if request.url in spider.model_urls:
            # 五大板块对应的响应对象
            # 实例化一个新的响应对象（包含动态加载的数据），替换原来的响应对象
            # 如何获取动态加载的新闻数据
            # 基于selenium便捷获取动态加载的数据
            bro = spider.bro  # 获取在爬虫类中定义的浏览器对象
            bro.get(request.url)  # 五大板块对应的url进行请求的发送
            sleep(2)
            page_text = bro.page_source  # 包含了动态加载的新闻数据
            new_response = HtmlResponse(url=request.url, body=page_text, encoding='utf-8', request=request)
            return new_response
        else:
            # 其它请求对应的响应对象
            return response

    def process_exception(self, request, exception, spider):
        # Called when a download handler or a process_request()
        # (from other downloader middleware) raises an exception.

        # Must either:
        # - return None: continue processing this exception
        # - return a Response object: stops process_exception() chain
        # - return a Request object: stops process_exception() chain
        pass


