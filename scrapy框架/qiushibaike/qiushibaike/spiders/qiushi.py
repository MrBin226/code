import scrapy
from qiushibaike.items import QiushibaikeItem

class QiushiSpider(scrapy.Spider):
    name = 'qiushi'
    # allowed_domains = ['www.qiushibaike.com']
    start_urls = ['https://www.qiushibaike.com/text/']

    # 基于终端指令
    # def parse(self, response):
    #     # 解析作者名称+写的段子内容
    #     articles = response.xpath('//div[@class="article block untagged mb15 typs_hot"]')
    #     all_data = []
    #     for article in articles:
    #         article_author = article.xpath('.//h2/text()').extract()[0]
    #         article_content = article.xpath('.//div[@class="content"]/span[1]//text()').extract()[0]
    #         print('*' * 50)
    #         print(article_author, article_content)
    #
    #         author_info = {
    #             'author': article_author,
    #             'content': article_content
    #         }
    #         all_data.append(author_info)
    #     return all_data

    # 基于管道
    def parse(self, response):
        # 解析作者名称+写的段子内容
        articles = response.xpath('//div[@class="article block untagged mb15 typs_hot"]')
        for article in articles:
            article_author = article.xpath('.//h2/text()').extract()[0]
            article_content = article.xpath('.//div[@class="content"]/span[1]//text()').extract()[0]
            print('*' * 50)
            print(article_author, article_content)

            item = QiushibaikeItem()
            item['author'] = article_author
            item['content'] = article_content

            yield item  # 将item提交给管道
