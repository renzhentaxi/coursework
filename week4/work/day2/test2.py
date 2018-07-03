#!/usr/bin/env python3
import requests
import sys
import math
import time

ARTICLE_SEARCH_URL = 'https://api.nytimes.com/svc/search/v2/articlesearch.json'
LIMIT = 1000
EXTRACT_LIST = ['web_url', 'pub_date','snippet']

def get(api_key, section, count):
    params = {'api-key': api_key, 'fq': 'section_name:(\"{}\")'.format(section), 'sort':'newest'}
    data = []
    for i in range(math.ceil(count/10)):
        params['page'] = i
        r = requests.get(ARTICLE_SEARCH_URL, params)
        json = r.json()['response']['docs']
        data.extend(json)
        time.sleep(1)
    return data

def process(data, extract_list, section):
    processed_data = []
    for i in data:
        item = [section]
        for e in EXTRACT_LIST:
            item.append(i[e].replace('\t',' ').replace('\n',''))
        processed_data.append(item)
    return processed_data

def toString(data):
    result = []
    for i in data:
        result.append("\t".join(i))
    return '\n'.join(result)

def collect(api_key, sectionList, extractList, count):
    colNames = ['section'] + extractList
    result = [colNames]
    for section in sectionList:
        json = get(api_key, section, count)
        processed = process(json, extractList, section)
        result.extend(processed)
    return result
    
if __name__ == '__main__':
    if len(sys.argv) < 4:
        sys.stderr.write('usage: %s <api_key> <count> <section>...\n ' % sys.argv[0])
        sys.exit(1)
    api_key = sys.argv[1]
    count = int(sys.argv[2])
    sections = sys.argv[3:]
    
    result = collect(api_key, sections, EXTRACT_LIST, count)
    string = toString(result)
    with open('data.tsv','w') as tsv:
        tsv.write(string)
