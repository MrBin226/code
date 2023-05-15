# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter


class WangyiproPipeline:
    fv = None

    def open_spider(self, spider):
        print("爬虫开启中。。。")
        self.fv = open('./qiushi1.txt', 'w', encoding='utf-8')

    def process_item(self, item, spider):
        author = item["title"]
        content = item["content"]

        self.fv.write(author + ':' + content + '\n')

        return item

    def close_spider(self, spider ):
        print("爬虫结束了...")
        self.fv.close()
