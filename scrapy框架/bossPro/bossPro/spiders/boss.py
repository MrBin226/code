import scrapy


class BossSpider(scrapy.Spider):
    name = 'boss'
    # allowed_domains = ['xxx.com']
    start_urls = ['https://www.zhipin.com/job_detail/?ka=header-job']

    def parse(self, response):
        job_names = response.xpath('//div[@class="job-list"]/ul//span[@class="job-name"]/a/text()').extract()
        for job_name in job_names:
            print(job_name)
