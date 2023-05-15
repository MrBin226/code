# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter


class DoubanPipeline:
    fv = None

    def open_spider(self, spider):
        print("爬虫开启中。。。")
        self.fv = open('./金刚川评论数据.csv', 'w', encoding='utf-8')

    def process_item(self, item, spider):
        self.fv.write(item["name"] + ',' + item["time"] +
                      ',' + item["score"] + ',' + item["content"] + '\n')
        return item

    def close_spider(self, spider ):
        print("爬虫结束了...")
        self.fv.close()
