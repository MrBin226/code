# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter

# 数据一份存储到txt，一份存储到csv文件

class QiushibaikePipeline:
    fp = None

    # 重写父类的一个方法：该方法只在开始爬虫的时候被调用一次
    def open_spider(self, spider):
        print("爬虫开启中。。。")
        self.fp = open('./qiushi.txt', 'w', encoding='utf-8')

    # 该方法每接收一个item，就会被调用一次
    def process_item(self, item, spider):
        author = item["author"]
        content = item["content"]

        self.fp.write(author + ':' + content + '\n')

        return item  # 就会把item继续提交给下一个item类

    # 结束爬虫时被调用一次
    def close_spider(self, spider ):
        print("爬虫结束了...")
        self.fp.close()


class CsvPipeline(object):
    fv = None

    def open_spider(self, spider):
        print("爬虫开启中。。。")
        self.fv = open('./qiushi1.csv', 'w', encoding='utf-8')

    def process_item(self, item, spider):
        author = item["author"]
        content = item["content"]

        self.fv.write(author + ':' + content + '\n')

        return item

    def close_spider(self, spider ):
        print("爬虫结束了...")
        self.fv.close()