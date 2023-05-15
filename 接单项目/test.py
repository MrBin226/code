import pdfplumber
import os

name = ['本期费用化研发投入','本期资本化研发投入','研发投入合计','研发投入总额占营业收入比例（%）','研发投入资本化的比重（%）']


read_path = r'E:\pythonworkspace\接单项目\pdf文件'
filelist = os.listdir(read_path)

for file in filelist:
    pdf = pdfplumber.open(read_path + '\\' + file)
    data = []
    flag = True
    for page in pdf.pages:
        txt = page.extract_text()
        if "资本化" in txt:
            flag = False
            table = page.extract_tables()
            table = sum(table, [])
            if table is None:
                continue
            # table = [ta for ta in table if len(ta) == 2]
            for ta in table:
                if ta is None or ta[0] is None:
                    continue
                if "资本化" in ta[0]:
                    data.append(ta)
    if flag:
        print(f"{file}中没有此数据")
    else:
        print(file, data)
